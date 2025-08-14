import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../widgets/grid_cell_widget.dart';
import 'package:flutter/foundation.dart';

class Level3Screen extends ConsumerStatefulWidget {
  const Level3Screen({super.key});

  @override
  ConsumerState<Level3Screen> createState() => _Level3ScreenState();
}

class _Level3ScreenState extends ConsumerState<Level3Screen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        final gameNotifier = ref.read(gameProvider.notifier);
        final currentLevel = ref.read(gameProvider).level;
        print('Level3Screen initState - Current Level: $currentLevel');
        
        // Only advance level if coming from earlier levels
        // If already Level 3, don't change anything (for refresh scenarios)
        if (currentLevel == 1) {
          gameNotifier.nextLevel(); // 1 → 2
          gameNotifier.nextLevel(); // 2 → 3
          print('Level3Screen - Advanced from Level 1 to 3');
        } else if (currentLevel == 2) {
          gameNotifier.nextLevel(); // 2 → 3
          print('Level3Screen - Advanced from Level 2 to 3');
        } else if (currentLevel == 3) {
          print('Level3Screen - Already at Level 3, keeping current state');
        }
        
        _initialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5), // Same purple background as Level 1
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: () {
            // Debug feature: Force complete level
            gameNotifier.forceCompleteLevel();
          },
          child: Text(
            'Number Master - Level ${gameState.level}/3',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF7B1FA2), // Purple
        foregroundColor: Colors.white,
        elevation: 8,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${gameState.score}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Back to Level 1 button - Removed to clean AppBar
          // TextButton(
          //   onPressed: () {
          //     Navigator.of(context).popUntil((route) => route.isFirst);
          //   },
          //   child: const Text(
          //     'L1',
          //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //   ),
          // ),
          // Back to Level 2 button - Removed to prevent duplicate navigation
          // TextButton(
          //   onPressed: () => Navigator.pop(context),
          //   child: const Text(
          //     'L2',
          //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //   ),
          // ),
        ],
      ),
      body: Stack(
        children: [
          // Main game content
          Column(
            children: [
              // Enhanced timer and info section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF7B1FA2),
                      Color(0xFF8E24AA),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Time Left',
                            '${gameState.timeRemaining}s',
                            Icons.timer,
                            gameState.timeRemaining <= 30 ? Colors.red : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            'Level Progress',
                            '${gameState.level}/3',
                            Icons.trending_up,
                            Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            'Rows Added',
                            '${gameState.addedRows}/${gameState.maxAddRows}',
                            Icons.add_box,
                            gameState.addedRows >= gameState.maxAddRows - 1 
                              ? Colors.orange 
                              : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildProgressIndicator(gameState),
                  ],
                ),
              ),

              // Game grid section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Game controls row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            'Add Row',
                            Icons.add,
                            gameState.addedRows < gameState.maxAddRows && !gameState.isGameOver
                              ? () => gameNotifier.addRandomRow()
                              : null,
                            gameState.addedRows >= gameState.maxAddRows
                              ? Colors.grey
                              : const Color(0xFF4CAF50),
                          ),
                          _buildActionButton(
                            'Reset',
                            Icons.refresh,
                            !gameState.isGameOver
                              ? () => gameNotifier.resetGame()
                              : null,
                            const Color(0xFF2196F3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Game board
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.white.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: gameState.board.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B1FA2)),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Loading Level ${gameState.level}...',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF7B1FA2),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(12),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: gameState.board[0].length,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemCount: gameState.board.fold<int>(0, (total, row) => total + row.length),
                                  itemBuilder: (context, index) {
                                    int rows = gameState.board.length;
                                    int cols = gameState.board[0].length;
                                    int row = index ~/ cols;
                                    int col = index % cols;
                                    
                                    if (row >= rows) return const SizedBox();
                                    
                                    return GridCellWidget(
                                      cell: gameState.board[row][col],
                                    );
                                  },
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

          // Enhanced overlay dialogs
          if (gameState.isGameOver)
            _buildGameOverDialog(context, gameNotifier, gameState),
          if (gameState.isLevelComplete)
            _buildLevelCompleteDialog(context, gameNotifier, gameState),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(GameState gameState) {
    int totalCells = 0;
    int matchedCells = 0;
    
    for (final row in gameState.board) {
      for (final cell in row) {
        if (!cell.isEmpty) {
          totalCells++;
          if (cell.isMatched) {
            matchedCells++;
          }
        }
      }
    }
    
    final progress = totalCells > 0 ? matchedCells / totalCells : 0.0;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress: $matchedCells/$totalCells',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: textColor.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback? onPressed, Color color) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            elevation: 8,
            shadowColor: color.withOpacity(0.4),
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: onPressed != null ? const Color(0xFF7B1FA2) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCompleteDialog(BuildContext context, GameNotifier gameNotifier, GameState gameState) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.military_tech,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                '🏆 LEVEL 3 COMPLETE! 🏆',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'CONGRATULATIONS!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Final Score: ${gameState.score}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You are a Number Master!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    gameNotifier.resetGame(); // Go back to level 1
                    Navigator.of(context).popUntil((route) => route.isFirst); // Go to Level 1
                  },
                  icon: const Icon(Icons.home),
                  label: const Text(
                    'Back to Level 1',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7B1FA2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    gameNotifier.resetGame();
                    Navigator.of(context).pop(); // Close dialog - stay in Level 3
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text(
                    'Play Level 3 Again',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverDialog(BuildContext context, GameNotifier gameNotifier, GameState gameState) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE53935), Color(0xFFEF5350)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Game Over!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Final Score: ${gameState.score}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      print('Try Again clicked - Level 3'); // Debug log
                      final gameNotifier = ref.read(gameProvider.notifier);
                      gameNotifier.tryAgain(); // Use same logic as Level 1
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text('Try Level ${gameState.level} Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      gameNotifier.resetGame(); // Go back to Level 1
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).popUntil((route) => route.isFirst); // Go to Level 1
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Start Over'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Exit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
