// A firmware panic on a USB-Serial-JTAG port arrives as plain text on the
// same wire as NDJSON. Surfacing it in the entry list is not enough — the
// renderer must actually show the text, otherwise the user sees an empty
// "evt device output" row and the crash evidence is still invisible.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skapp/features/dev/usb_console_providers.dart';
import 'package:skapp/features/dev/widgets/console_message_view.dart';

void main() {
  testWidgets('plain-text device output is rendered verbatim', (tester) async {
    const panic = 'Guru Meditation Error: Core 0 panic\'ed (LoadProhibited)';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ConsoleMessageView(
          entry: ConsoleEntryEvent(evt: 'device output', raw: panic),
        ),
      ),
    ));

    expect(find.text(panic), findsOneWidget,
        reason: 'non-JSON device output must be shown, not silently blank');
  });

  testWidgets('structured events still render as key/value', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ConsoleMessageView(
          entry: ConsoleEntryEvent(
            evt: 'battery.sample',
            raw: '{"evt":"battery.sample","pct":87}',
          ),
        ),
      ),
    ));

    // The decoded payload is shown as key/value, and the raw JSON is NOT
    // dumped as text (that path is only for non-JSON output).
    expect(find.textContaining('87'), findsWidgets);
    expect(find.text('{"evt":"battery.sample","pct":87}'), findsNothing);
  });
}
