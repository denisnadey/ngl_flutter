class AtomInfo {
  final String element; // Химический элемент (например, "C", "H", "O")
  final int index; // Индекс атома (числовое значение)
  final String residue; // Название остатка (например, "ALA")

  AtomInfo({
    required this.element,
    required this.index,
    required this.residue,
  });

  // Преобразование из JSON
  factory AtomInfo.fromJson(Map<String, dynamic> json) {
    return AtomInfo(
      element: json['element'] as String,
      index: json['index'] as int,
      residue: json['residue'] as String,
    );
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'element': element,
      'index': index,
      'residue': residue,
    };
  }

  @override
  String toString() {
    return 'AtomInfo(element: $element, index: $index, residue: $residue)';
  }
}
