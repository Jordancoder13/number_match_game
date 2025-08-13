class LevelConfig {
  final int level;
  final int rows;
  final int cols;
  final int timeLimit; // in seconds
  final List<int> numberPool;
  final String description;
  final double sparsity; // 0.0 = fully filled, 0.3 = 30% empty cells
  final int maxAddRows; // Maximum rows that can be added

  const LevelConfig({
    required this.level,
    required this.rows,
    this.cols = 6,
    required this.timeLimit,
    required this.numberPool,
    required this.description,
    this.sparsity = 0.0,
    this.maxAddRows = 3,
  });
}

class GameLevels {
  static const List<LevelConfig> levels = [
    LevelConfig(
      level: 1,
      rows: 4,
      cols: 6,
      timeLimit: 120, // 2 minutes
      numberPool: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      description: 'Beginner - Learn the basics',
      sparsity: 0.2, // 20% empty cells for Number Master feel
      maxAddRows: 2,
    ),
    LevelConfig(
      level: 2,
      rows: 5,
      cols: 6,
      timeLimit: 120,
      numberPool: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      description: 'Intermediate - More challenging',
      sparsity: 0.15, // 15% empty cells
      maxAddRows: 3,
    ),
    LevelConfig(
      level: 3,
      rows: 6,
      cols: 6,
      timeLimit: 120,
      numberPool: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      description: 'Advanced - Master level',
      sparsity: 0.1, // 10% empty cells
      maxAddRows: 4,
    ),
  ];

  static LevelConfig getLevel(int level) {
    return levels.firstWhere(
      (config) => config.level == level,
      orElse: () => levels.first,
    );
  }
}
