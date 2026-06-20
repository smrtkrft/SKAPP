/// Shared kebab-case guard for SKAPI platform and script identifiers.
///
/// Applied in both the HTTP router (`skapp_http_server.dart`) and the
/// file-system accessor (`override_storage.dart`, `script_repository.dart`)
/// so path-traversal sequences like `../` or absolute paths are rejected at
/// every boundary rather than only at the HTTP layer.
final RegExp kAssetIdPattern = RegExp(r'^[a-z0-9][a-z0-9-]*$');
