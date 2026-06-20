import '../../features/devices/bf/bf_plugin.dart';
import '../../features/devices/lebensspur/ls_plugin.dart';
import '../../features/devices/ms/ms_plugin.dart';
import 'device_plugin.dart';

/// Single source of truth mapping a device identity prefix to its plugin.
///
/// Adding a SmartKraft device family is now: write one `XxxPlugin` and add
/// one line here. Every type → home screen / icon / event catalog / peer-kind
/// decision flows through [pluginFor]; unknown prefixes return `null` and the
/// caller falls back (e.g. the unsupported-device card).
const Map<String, DevicePlugin> devicePluginRegistry = {
  'BF': BfPlugin(),
  'LS': LsPlugin(),
  'MS': MsPlugin(),
};

/// Resolves the plugin for [prefix], or `null` for an unknown / null prefix.
DevicePlugin? pluginFor(String? prefix) =>
    prefix == null ? null : devicePluginRegistry[prefix];
