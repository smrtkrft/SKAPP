import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_logger.dart';

/// Helpers to get diagnostic logs OUT of the app to the user, so they can
/// attach them to a GitHub issue. No network/telemetry: the user is always the
/// one who chooses to export. Desktop = copy + reveal folder; mobile = OS
/// share sheet. Preserves SKAPP's "no cloud" property.

/// Reveal-in-file-manager only makes sense on desktop.
bool get logFolderRevealSupported =>
    !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

/// The OS share sheet is the natural attach flow on mobile.
bool get logShareSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

/// Copies the full log to the clipboard (works on every platform).
Future<void> copyLogsToClipboard() async {
  final text = await AppLogger.instance.dump();
  await Clipboard.setData(ClipboardData(text: text));
}

/// Opens the folder containing the log file in the OS file manager.
/// Returns false if the path could not be resolved / opened.
Future<bool> openLogFolder() async {
  final file = AppLogger.instance.file;
  if (file == null) return false;
  try {
    return await launchUrl(Uri.file(file.parent.path));
  } catch (_) {
    return false;
  }
}

/// Hands the log file to the OS share sheet (mobile). Falls back to sharing
/// the in-RAM dump as text if the file is unavailable.
Future<void> shareLogs() async {
  final file = AppLogger.instance.file;
  if (file != null && await file.exists()) {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], subject: 'SKAPP logs'),
    );
    return;
  }
  final text = await AppLogger.instance.dump();
  await SharePlus.instance.share(
    ShareParams(text: text, subject: 'SKAPP logs'),
  );
}
