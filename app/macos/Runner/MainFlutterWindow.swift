import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    // Process argümanlarını Dart `main(List<String> args)`'a geçir.
    // Varsayılan FlutterViewController() args'ı iletmez → macOS'ta Dart
    // tarafı her zaman boş args görür. launch_at_startup LaunchAgent'ı
    // `--hidden` ile başlattığında bu flag'in main.dart'a ulaşması için
    // FlutterDartProject.dartEntrypointArguments üzerinden aktarıyoruz
    // (ilk eleman çalıştırılabilir yolu olduğu için atlanır).
    let project = FlutterDartProject()
    project.dartEntrypointArguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
    let flutterViewController = FlutterViewController(project: project)
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
