import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../widgets/grid_cell_widget.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Number Match - Level ${gameState.level}'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Score: ${gameState.score}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main game content
          Column(
            children: [
              // Timer and game info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: gameState.timeRemaining <= 30 
                              ? Colors.red 
                              : Colors.blue.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(gameState.timeRemaining),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: gameState.timeRemaining <= 30 
                                ? Colors.red 
                                : Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Match equal numbers or sum to 10',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Game grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            childAspectRatio: 1,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: _getTotalCells(gameState.board),
                          itemBuilder: (context, index) {
                            final cell = _getCellAtIndex(gameState.board, index);
                            return GridCellWidget(cell: cell);
                          },
                        ),
                      ),
                      
                      // Add Row button (simplified for now)
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: gameState.isGameOver ? null : () {
                            gameNotifier.addRandomRow();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'Add Row',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Overlay dialogs
          if (gameState.isGameOver)
            _buildGameOverDialog(context, gameNotifier, gameState),
          if (gameState.isLevelComplete)
            _buildLevelCompleteDialog(context, gameNotifier, gameState),
        ],
      ),
    );
  }

  Widget _buildGameOverDialog(BuildContext context, GameNotifier gameNotifier, gameState) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Time\'s Up!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Final Score: ${gameState.score}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => gameNotifier.restartLevel(),
                      child: const Text('Retry Level'),
                    ),
                    ElevatedButton(
                      onPressed: () => gameNotifier.resetGame(),
                      child: const Text('Start Over'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCompleteDialog(BuildContext context, GameNotifier gameNotifier, gameState) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.celebration,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Level Complete!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: ${gameState.score}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Time Bonus: ${gameState.timeRemaining * 2}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                if (gameState.level < 3)
                  ElevatedButton(
                    onPressed: () => gameNotifier.nextLevel(),
                    child: const Text('Next Level'),
                  )
                else
                  Column(
                    children: [
                      const Text(
                        'Congratulations! You completed all levels!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => gameNotifier.resetGame(),
                        child: const Text('Play Again'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  int _getTotalCells(List<List<dynamic>> board) {
    return board.fold(0, (sum, row) => sum + row.length);
  }

  dynamic _getCellAtIndex(List<List<dynamic>> board, int index) {
    int currentIndex = 0;
    for (final row in board) {
      for (final cell in row) {
        if (currentIndex == index) {
          return cell;
        }
        currentIndex++;
      }
    }
    throw RangeError('Index $index out of range');
  }
}
