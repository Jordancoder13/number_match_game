// Platform utilities for cross-platform functionality
import 'package:flutter/foundation.dart';

class PlatformUtils {
  static void refreshPage() {
    if (kIsWeb) {
      // On web, we would refresh the page
      // But for APK compatibility, we'll just do nothing here
      // The actual page refresh will be handled in the web-specific file
    }
    // For mobile platforms, do nothing - handled by double restart
  }
}
