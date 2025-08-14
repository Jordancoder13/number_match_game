import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cell.dart';
import '../models/level_config.dart';

class GameState {
  final List<List<Cell>> board;
  final int level;
  final int score;
  final int timeRemaining; // in seconds
  final String? selectedCell1;
  final String? selectedCell2;
  final bool isProcessingMatch;
  final bool isGameOver;
  final bool isLevelComplete;
  final int addedRows; // Track how many rows have been added
  final int maxAddRows; // Maximum rows that can be added for current level

  const GameState({
    required this.board,
    required this.level,
    required this.score,
    required this.timeRemaining,
    this.selectedCell1,
    this.selectedCell2,
    this.isProcessingMatch = false,
    this.isGameOver = false,
    this.isLevelComplete = false,
    this.addedRows = 0,
    this.maxAddRows = 5, // Default minimum of 5 rows
  });

  /// Creates an initial game state for a given level
  factory GameState.initial(int level) {
    final levelConfig = GameLevels.getLevel(level);
    return GameState(
      board: _generateBoard(levelConfig),
      level: level,
      score: 0,
      timeRemaining: levelConfig.timeLimit,
      selectedCell1: null,
      selectedCell2: null,
      isProcessingMatch: false,
      isGameOver: false,
      isLevelComplete: false,
      addedRows: 0,
      maxAddRows: levelConfig.maxAddRows,
    );
  }

  /// Creates a copy of this state with optional new values
  GameState copyWith({
    List<List<Cell>>? board,
    int? level,
    int? score,
    int? timeRemaining,
    String? selectedCell1,
    String? selectedCell2,
    bool? isProcessingMatch,
    bool? isGameOver,
    bool? isLevelComplete,
    int? addedRows,
    int? maxAddRows,
    bool clearSelectedCell1 = false,
    bool clearSelectedCell2 = false,
  }) {
    return GameState(
      board: board ?? this.board,
      level: level ?? this.level,
      score: score ?? this.score,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      selectedCell1: clearSelectedCell1 ? null : (selectedCell1 ?? this.selectedCell1),
      selectedCell2: clearSelectedCell2 ? null : (selectedCell2 ?? this.selectedCell2),
      isProcessingMatch: isProcessingMatch ?? this.isProcessingMatch,
      isGameOver: isGameOver ?? this.isGameOver,
      isLevelComplete: isLevelComplete ?? this.isLevelComplete,
      addedRows: addedRows ?? this.addedRows,
      maxAddRows: maxAddRows ?? this.maxAddRows,
    );
  }

  /// Generates initial board for a given level (Number Master style - sparse)
  static List<List<Cell>> _generateBoard(LevelConfig levelConfig) {
    final random = Random();
    final rows = levelConfig.rows;
    final cols = levelConfig.cols;
    
    final board = <List<Cell>>[];
    int cellIdCounter = 0;

    // Create a weighted number pool to ensure more matching opportunities
    final weightedPool = <int>[];
    
    // Add pairs that equal 10: (1,9), (2,8), (3,7), (4,6), (5,5)
    for (int i = 0; i < 4; i++) {
      weightedPool.addAll([1, 9, 2, 8, 3, 7, 4, 6, 5]);
    }
    
    // Add some duplicate numbers for exact matches
    for (int i = 1; i <= 9; i++) {
      weightedPool.addAll([i, i, i]); // Add each number three times
    }

    for (int row = 0; row < rows; row++) {
      final rowCells = <Cell>[];
      for (int col = 0; col < cols; col++) {
        // Apply sparsity - some cells will be empty (Number Master style)
        final isEmpty = random.nextDouble() < levelConfig.sparsity;
        
        if (isEmpty) {
          rowCells.add(Cell(
            id: 'cell_${cellIdCounter++}',
            value: 0, // 0 represents empty
            isEmpty: true,
          ));
        } else {
          final value = weightedPool[random.nextInt(weightedPool.length)];
          rowCells.add(Cell(
            id: 'cell_${cellIdCounter++}',
            value: value,
            isEmpty: false,
          ));
        }
      }
      board.add(rowCells);
    }

    return board;
  }

  /// Checks if level is complete based on different criteria for each level
  bool get allCellsMatched {
    int totalCells = 0;
    int matchedCells = 0;
    
    for (final row in board) {
      for (final cell in row) {
        if (!cell.isEmpty) { // Only count non-empty cells
          totalCells++;
          if (cell.isMatched) {
            matchedCells++;
          }
        }
      }
    }
    
    if (totalCells == 0) return false;
    
    // Different completion criteria for each level
    switch (level) {
      case 1:
        // Level 1: Easy - Complete when 70% cells are matched
        return (matchedCells / totalCells) >= 0.7;
      case 2:
      case 3:
        // Level 2 & 3: Hard - Complete only when ALL cells are matched
        return matchedCells == totalCells;
      default:
        return matchedCells == totalCells;
    }
  }

  /// Alternative: Check if player has made good progress (for easier jo tion)
  bool get hasGoodProgress {
    int totalCells = 0;
    int matchedCells = 0;
    
    for (final row in board) {
      for (final cell in row) {
        totalCells++;
        if (cell.isMatched) {
          matchedCells++;
        }
      }
    }
    
    return totalCells > 0 && (matchedCells / totalCells) >= 0.6; // 60% completion
  }

  /// Gets a cell by its ID
  Cell? getCellById(String cellId) {
    for (final row in board) {
      for (final cell in row) {
        if (cell.id == cellId) {
          return cell;
        }
      }
    }
    return null;
  }
}

class GameNotifier extends StateNotifier<GameState> {
  Timer? _gameTimer;

  GameNotifier() : super(GameState.initial(1)) {
    startGameTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  /// Starts the game timer
  void startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining <= 0) {
        timer.cancel();
        state = state.copyWith(isGameOver: true);
      } else {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      }
    });
  }

  /// Handles cell selection logic with enhanced visual feedback
  void selectCell(String cellId) {
    if (state.isProcessingMatch || state.isGameOver) return;

    final cell = state.getCellById(cellId);
    if (cell == null || cell.isMatched || cell.isEmpty) return;

    // If cell is already selected, deselect it
    if (state.selectedCell1 == cellId) {
      state = state.copyWith(clearSelectedCell1: true);
      state = _updateCellInBoard(cellId, (cell) => cell.copyWith(
        isSelected: false,
        animationState: CellAnimationState.none,
      ));
      return;
    }
    
    if (state.selectedCell2 == cellId) {
      state = state.copyWith(clearSelectedCell2: true);
      state = _updateCellInBoard(cellId, (cell) => cell.copyWith(
        isSelected: false,
        animationState: CellAnimationState.none,
      ));
      return;
    }

    // If no cells selected, select this one
    if (state.selectedCell1 == null) {
      state = state.copyWith(selectedCell1: cellId);
      state = _updateCellInBoard(cellId, (cell) => cell.copyWith(
        isSelected: true,
        animationState: CellAnimationState.selected,
      ));
    }
    // If one cell selected, select this as second and check for match
    else if (state.selectedCell2 == null) {
      state = state.copyWith(selectedCell2: cellId);
      state = _updateCellInBoard(cellId, (cell) => cell.copyWith(
        isSelected: true,
        animationState: CellAnimationState.selected,
      ));
      
      // Check for match after a small delay for visual feedback
      Future.delayed(const Duration(milliseconds: 200), () {
        _checkAndProcessMatch();
      });
    }
  }

  /// Checks if two cells match and processes the result with enhanced visual feedback
  void _checkAndProcessMatch() {
    if (state.selectedCell1 == null || state.selectedCell2 == null) return;

    state = state.copyWith(isProcessingMatch: true);

    final cell1 = state.getCellById(state.selectedCell1!);
    final cell2 = state.getCellById(state.selectedCell2!);

    if (cell1 == null || cell2 == null) {
      _clearSelection();
      return;
    }

    final isMatch = _checkMatch(cell1, cell2);

    if (isMatch) {
      // Valid match - show success animation then mark as matched
      state = _updateCellInBoard(cell1.id, (cell) => 
          cell.copyWith(animationState: CellAnimationState.validMatch));
      state = _updateCellInBoard(cell2.id, (cell) => 
          cell.copyWith(animationState: CellAnimationState.validMatch));
      
      // After animation, mark as matched
      Future.delayed(const Duration(milliseconds: 400), () {
        state = _updateCellInBoard(cell1.id, (cell) => 
            cell.copyWith(
              isMatched: true, 
              isSelected: false,
              animationState: CellAnimationState.matched,
            ));
        state = _updateCellInBoard(cell2.id, (cell) => 
            cell.copyWith(
              isMatched: true, 
              isSelected: false,
              animationState: CellAnimationState.matched,
            ));
        
        // Update score
        state = state.copyWith(score: state.score + 10);
        
        // Check if level is complete
        if (state.allCellsMatched) {
          state = state.copyWith(isLevelComplete: true);
          _gameTimer?.cancel();
        }
        
        _clearSelection();
      });
    } else {
      // Invalid match - show error animation
      state = _updateCellInBoard(cell1.id, (cell) => 
          cell.copyWith(animationState: CellAnimationState.invalidMatch));
      state = _updateCellInBoard(cell2.id, (cell) => 
          cell.copyWith(animationState: CellAnimationState.invalidMatch));
      
      // After animation, reset selection
      Future.delayed(const Duration(milliseconds: 600), () {
        state = _updateCellInBoard(cell1.id, (cell) => cell.copyWith(
          isSelected: false,
          animationState: CellAnimationState.none,
        ));
        state = _updateCellInBoard(cell2.id, (cell) => cell.copyWith(
          isSelected: false,
          animationState: CellAnimationState.none,
        ));
        
        _clearSelection();
      });
    }
  }

  /// Checks if two cells match (equal or sum to 10)
  bool _checkMatch(Cell cell1, Cell cell2) {
    return cell1.value == cell2.value || cell1.value + cell2.value == 10;
  }

  /// Clears current selection
  void _clearSelection() {
    state = state.copyWith(
      clearSelectedCell1: true,
      clearSelectedCell2: true,
      isProcessingMatch: false,
    );
  }

  /// Updates a specific cell in the board
  GameState _updateCellInBoard(String cellId, Cell Function(Cell) updater) {
    final newBoard = <List<Cell>>[];
    
    for (final row in state.board) {
      final newRow = <Cell>[];
      for (final cell in row) {
        if (cell.id == cellId) {
          newRow.add(updater(cell));
        } else {
          newRow.add(cell);
        }
      }
      newBoard.add(newRow);
    }

    return state.copyWith(board: newBoard);
  }

  /// Adds a new row of random numbers (with limits like Number Master)
  void addRandomRow() {
    if (state.isGameOver || state.addedRows >= state.maxAddRows) return;

    final random = Random();
    final levelConfig = GameLevels.getLevel(state.level);
    final cols = levelConfig.cols;
    final newRow = <Cell>[];
    
    // Use the same weighted algorithm as board generation
    final weightedPool = <int>[];
    for (int i = 0; i < 2; i++) {
      weightedPool.addAll([1, 9, 2, 8, 3, 7, 4, 6, 5]);
    }
    for (int i = 1; i <= 9; i++) {
      weightedPool.add(i);
    }
    
    // Generate a unique ID for new cells
    int maxId = 0;
    for (final row in state.board) {
      for (final cell in row) {
        final idNum = int.tryParse(cell.id.replaceAll('cell_', '')) ?? 0;
        if (idNum > maxId) maxId = idNum;
      }
    }

    for (int col = 0; col < cols; col++) {
      // Apply some sparsity to new rows too
      final isEmpty = random.nextDouble() < (levelConfig.sparsity * 0.5); // Less sparse than initial
      
      if (isEmpty) {
        newRow.add(Cell(
          id: 'cell_${++maxId}',
          value: 0,
          isEmpty: true,
        ));
      } else {
        final value = weightedPool[random.nextInt(weightedPool.length)];
        newRow.add(Cell(
          id: 'cell_${++maxId}',
          value: value,
          isEmpty: false,
        ));
      }
    }

    final newBoard = [...state.board, newRow];
    state = state.copyWith(
      board: newBoard,
      addedRows: state.addedRows + 1,
    );
  }

  /// Check if more rows can be added
  bool get canAddMoreRows => state.addedRows < state.maxAddRows;

  /// Starts next level with enhanced scoring
  void nextLevel() {
    print('Advancing from Level ${state.level} to Level ${state.level + 1}');
    
    if (state.level < 3) {
      _gameTimer?.cancel();
      final newLevel = state.level + 1;
      final timeBonus = state.timeRemaining * 5; // Higher time bonus
      final newScore = state.score + timeBonus;
      
      state = GameState.initial(newLevel);
      state = state.copyWith(score: newScore);
      
      print('Successfully advanced to Level $newLevel (Score: $newScore)');
      
      startGameTimer();
    } else {
      print('Already at max level (${state.level}), not advancing');
    }
  }

  /// Force complete the current level (for testing or when player has good progress)
  void forceCompleteLevel() {
    if (state.hasGoodProgress) {
      state = state.copyWith(isLevelComplete: true);
      _gameTimer?.cancel();
    }
  }

  /// Restarts current level
  void restartLevel() {
    _gameTimer?.cancel();
    state = GameState.initial(state.level);
    startGameTimer();
  }

  /// Resets current level (doesn't go back to level 1) - SIMPLE VERSION
  void resetCurrentLevel() {
    final currentLevel = state.level;
    final currentScore = state.score;
    print('resetCurrentLevel called with level: $currentLevel, score: $currentScore'); // Debug
    
    _gameTimer?.cancel();
    
    // Create completely fresh level but keep level number and score
    final levelConfig = GameLevels.getLevel(currentLevel);
    state = GameState(
      board: GameState._generateBoard(levelConfig),
      level: currentLevel, // Same level
      score: currentScore, // Keep score
      timeRemaining: levelConfig.timeLimit,
      selectedCell1: null,
      selectedCell2: null,
      isProcessingMatch: false,
      isGameOver: false,
      isLevelComplete: false,
      addedRows: 0,
      maxAddRows: levelConfig.maxAddRows,
    );
    
    print('After reset - Level: ${state.level}, Score: ${state.score}'); // Debug
    startGameTimer();
  }

  /// Try Again functionality - Specifically for the Try Again button
  /// This ensures the current level is correctly identified and reset
  void tryAgain() {
    final currentLevelToReset = state.level;
    final currentScore = state.score;
    
    print('Try Again: Resetting Level $currentLevelToReset (Score: $currentScore)');
    
    // Cancel any running timer
    _gameTimer?.cancel();
    
    // Generate a fresh board for the EXACT same level
    final levelConfig = GameLevels.getLevel(currentLevelToReset);
    
    // Create completely new state with the same level but fresh game state
    state = GameState(
      board: GameState._generateBoard(levelConfig),
      level: currentLevelToReset, // CRITICAL: Use the exact current level
      score: currentScore, // Keep the score
      timeRemaining: levelConfig.timeLimit, // Reset timer
      selectedCell1: null,
      selectedCell2: null,
      isProcessingMatch: false,
      isGameOver: false, // Reset game over state
      isLevelComplete: false, // Reset level complete state
      addedRows: 0,
      maxAddRows: levelConfig.maxAddRows,
    );
    
    print('Try Again completed: Level ${state.level} reset successfully');
    
    // Start fresh timer
    startGameTimer();
  }

  /// Resets to level 1
  void resetGame() {
    _gameTimer?.cancel();
    state = GameState.initial(1);
    startGameTimer();
  }
}

/// Provider for the game state
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
