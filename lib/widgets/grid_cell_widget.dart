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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GridCellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Animate when cell becomes selected
    if (!oldWidget.cell.isSelected && widget.cell.isSelected) {
      _animationController.forward();
    } else if (oldWidget.cell.isSelected && !widget.cell.isSelected) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.read(gameProvider.notifier);

    return GestureDetector(
      onTap: () {
        gameNotifier.selectCell(widget.cell.id);
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.cell.isSelected ? _scaleAnimation.value : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: _getCellColor(),
                border: Border.all(
                  color: _getBorderColor(),
                  width: widget.cell.isSelected ? 3 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: widget.cell.isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : widget.cell.isMatched
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            )
                          ],
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.cell.isMatched 
                        ? Colors.grey.shade400 
                        : widget.cell.isSelected
                            ? Colors.blue.shade700
                            : Colors.black87,
                  ),
                  child: Text(
                    widget.cell.value.toString(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getCellColor() {
    if (widget.cell.isMatched) {
      return Colors.grey.shade100;
    } else if (widget.cell.isSelected) {
      return Colors.blue.shade50;
    } else {
      return Colors.white;
    }
  }

  Color _getBorderColor() {
    if (widget.cell.isMatched) {
      return Colors.grey.shade300;
    } else if (widget.cell.isSelected) {
      return Colors.blue.shade600;
    } else {
      return Colors.grey.shade300;
    }
  }
}
