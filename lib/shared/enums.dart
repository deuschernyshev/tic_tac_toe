enum CellValue {
  cross,
  zero,
  none,
}

extension CellValueX on CellValue {
  String get stringValue => switch (this) {
        CellValue.cross => 'X',
        CellValue.zero => 'O',
        CellValue.none => '',
      };

  String get valueName => switch (this) {
        CellValue.cross => 'Крестики',
        CellValue.zero => 'Нолики',
        CellValue.none => '',
      };
}
