// Web-specific platform utilities
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class PlatformUtils {
  static void refreshPage() {
    html.window.location.reload();
  }
}
