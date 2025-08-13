enum CellAnimationState {
  none,
  selected,
  validMatch,
  invalidMatch,
  matched
}

class Cell {
  final String id;
  final int value;
  final bool isMatched;
  final bool isSelected;
  final bool isEmpty; // For sparse grid like Number Master
  final CellAnimationState animationState;

  const Cell({
    required this.id,
    required this.value,
    this.isMatched = false,
    this.isSelected = false,
    this.isEmpty = false,
    this.animationState = CellAnimationState.none,
  });

  /// Creates a copy of this cell with optional new values
  Cell copyWith({
    String? id,
    int? value,
    bool? isMatched,
    bool? isSelected,
    bool? isEmpty,
    CellAnimationState? animationState,
  }) {
    return Cell(
      id: id ?? this.id,
      value: value ?? this.value,
      isMatched: isMatched ?? this.isMatched,
      isSelected: isSelected ?? this.isSelected,
      isEmpty: isEmpty ?? this.isEmpty,
      animationState: animationState ?? this.animationState,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cell &&
        other.id == id &&
        other.value == value &&
        other.isMatched == isMatched &&
        other.isSelected == isSelected &&
        other.isEmpty == isEmpty &&
        other.animationState == animationState;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        value.hashCode ^
        isMatched.hashCode ^
        isSelected.hashCode ^
        isEmpty.hashCode ^
        animationState.hashCode;
  }

  @override
  String toString() {
    return 'Cell(id: $id, value: $value, isMatched: $isMatched, isSelected: $isSelected, isEmpty: $isEmpty, animationState: $animationState)';
  }
}
