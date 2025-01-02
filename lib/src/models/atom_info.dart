class AtomInfo {
  final String element; // Химический элемент (например, "C", "H", "O")
  final int index; // Индекс атома (числовое значение)
  final String residue; // Название остатка (например, "ALA")
  final String x;
  final String y;
  final String z;

  AtomInfo({
    required this.element,
    required this.index,
    required this.residue,
    required this.x,
    required this.y,
    required this.z,
  });

  // Преобразование из JSON
  factory AtomInfo.fromJson(Map<String, dynamic> json) {
    return AtomInfo(
      element: json['element'] as String,
      index: json['index'] as int,
      residue: json['residue'] as String,
      x: json['x'] as String,
      y: json['y'] as String,
      z: json['z'] as String,
    );
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'element': element,
      'index': index,
      'residue': residue,
      'x': x,
      'y': y,
      'z': z,
    };
  }

  @override
  String toString() {
    return 'AtomInfo(element: $element, index: $index, residue: $residue, x: $x, y: $y, z: $z)';
  }
}
