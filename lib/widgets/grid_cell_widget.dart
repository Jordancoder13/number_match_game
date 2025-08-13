import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cell.dart';
import '../providers/game_provider.dart';

class GridCellWidget extends ConsumerStatefulWidget {
  final Cell cell;

  const GridCellWidget({
    super.key,
    required this.cell,
  });

  @override
  ConsumerState<GridCellWidget> createState() => _GridCellWidgetState();
}

class _GridCellWidgetState extends ConsumerState<GridCellWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Scale animation for selection
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Shake animation for invalid matches
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticInOut,
    ));

    // Fade animation for matched cells
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GridCellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle animation state changes
    switch (widget.cell.animationState) {
      case CellAnimationState.selected:
        _scaleController.forward();
        break;
      case CellAnimationState.none:
        _scaleController.reverse();
        break;
      case CellAnimationState.invalidMatch:
        _shakeController.reset();
        _shakeController.forward();
        break;
      case CellAnimationState.validMatch:
        _fadeController.forward();
        break;
      case CellAnimationState.matched:
        // Keep faded state
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.read(gameProvider.notifier);

    // Don't render empty cells
    if (widget.cell.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        gameNotifier.selectCell(widget.cell.id);
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _shakeAnimation, _fadeAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              widget.cell.animationState == CellAnimationState.invalidMatch
                  ? (_shakeAnimation.value * ((_shakeController.value * 4).round() % 2 == 0 ? 1 : -1))
                  : 0.0,
              0.0,
            ),
            child: Transform.scale(
              scale: widget.cell.isSelected ? _scaleAnimation.value : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: _getCellGradient(),
                  border: Border.all(
                    color: _getBorderColor(),
                    width: widget.cell.isSelected ? 3 : 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _getCellShadow(),
                ),
                child: Center(
                  child: Opacity(
                    opacity: widget.cell.isMatched ? 0.3 : 
                             (widget.cell.animationState == CellAnimationState.validMatch ? _fadeAnimation.value : 1.0),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(),
                        shadows: widget.cell.isSelected ? [
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ] : null,
                      ),
                      child: Text(
                        widget.cell.value.toString(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Number Master inspired color scheme
  LinearGradient _getCellGradient() {
    if (widget.cell.isMatched) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.grey.shade100,
          Colors.grey.shade200,
        ],
      );
    } else if (widget.cell.isSelected) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4FC3F7), // Light blue
          Color(0xFF29B6F6), // Darker blue
        ],
      );
    } else if (widget.cell.animationState == CellAnimationState.invalidMatch) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFF5252), // Light red
          Color(0xFFE57373), // Darker red
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFDE7), // Very light yellow
          Color(0xFFFFF9C4), // Light yellow
        ],
      );
    }
  }

  Color _getBorderColor() {
    if (widget.cell.isMatched) {
      return Colors.grey.shade300;
    } else if (widget.cell.isSelected) {
      return const Color(0xFF1976D2); // Strong blue
    } else if (widget.cell.animationState == CellAnimationState.invalidMatch) {
      return const Color(0xFFD32F2F); // Strong red
    } else {
      return const Color(0xFFFFB74D); // Orange border
    }
  }

  Color _getTextColor() {
    if (widget.cell.isMatched) {
      return Colors.grey.shade400;
    } else if (widget.cell.isSelected) {
      return Colors.white;
    } else if (widget.cell.animationState == CellAnimationState.invalidMatch) {
      return Colors.white;
    } else {
      return const Color(0xFF5D4037); // Brown text
    }
  }

  List<BoxShadow> _getCellShadow() {
    if (widget.cell.isSelected) {
      return [
        BoxShadow(
          color: const Color(0xFF2196F3).withOpacity(0.5),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];
    } else if (widget.cell.animationState == CellAnimationState.invalidMatch) {
      return [
        BoxShadow(
          color: const Color(0xFFF44336).withOpacity(0.5),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
      ];
    } else if (!widget.cell.isMatched) {
      return [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return [];
  }
}
