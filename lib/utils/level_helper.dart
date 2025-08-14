import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';

class LevelHelper {
  /// Reset current level and ensure proper state management
  static void resetCurrentLevel(WidgetRef ref, BuildContext context) {
    final gameNotifier = ref.read(gameProvider.notifier);
    final currentLevel = ref.read(gameProvider).level;
    
    print('LevelHelper.resetCurrentLevel called for level: $currentLevel');
    
    // Close any open dialogs first
    Navigator.of(context).pop();
    
    // Use a small delay to ensure dialog is closed
    Future.delayed(const Duration(milliseconds: 100), () {
      gameNotifier.resetCurrentLevel();
      
      // Force a rebuild of the widget tree
      Future.delayed(const Duration(milliseconds: 50), () {
        if (context.mounted) {
          // Force refresh by triggering a rebuild
          (context as Element).markNeedsBuild();
        }
      });
    });
  }
}
