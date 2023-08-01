import 'package:flutter/material.dart';
import 'package:tic_tac_toe/shared/enums.dart';

class CellButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final CellValue value;
  final Border? border;

  const CellButton({
    super.key,
    required this.onPressed,
    this.value = CellValue.none,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: border,
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: value != CellValue.none ? 1 : 0,
            duration: kThemeAnimationDuration,
            child: Text(
              value.stringValue,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: _signColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color get _signColor => switch (value) {
        CellValue.cross => Colors.red,
        CellValue.zero => Colors.deepPurple,
        _ => Colors.transparent,
      };
}
