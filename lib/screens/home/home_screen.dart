import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:tic_tac_toe/shared/enums.dart';
import 'package:tic_tac_toe/widgets/cell_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ShakeDetector shakeDetector;
  late List<List<CellValue>> _values;

  CellValue _currentSign = CellValue.cross;

  @override
  void initState() {
    _reset();

    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: _showResetDialog,
    );

    super.initState();
  }

  @override
  void dispose() {
    shakeDetector.stopListening();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('[ ${_currentSign.stringValue} ]'),
        actions: <Widget>[
          IconButton(
            onPressed: _showResetDialog,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ..._values.mapIndexed(
                (columnIndex, row) => Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ...row.mapIndexed(
                        (rowIndex, cellValue) => Expanded(
                          child: CellButton(
                            onPressed: _cellHasValue(columnIndex, rowIndex)
                                ? null
                                : () {
                                    _makeTurn(
                                      value: _currentSign,
                                      columnIndex: columnIndex,
                                      rowIndex: rowIndex,
                                    );
                                  },
                            value: cellValue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _cellHasValue(int columnIndex, int rowIndex) {
    return _values[columnIndex][rowIndex] != CellValue.none;
  }

  void _makeTurn({
    required CellValue value,
    required int columnIndex,
    required int rowIndex,
  }) {
    _setValueInCell(
      value: value,
      columnIndex: columnIndex,
      rowIndex: rowIndex,
    );

    _swapCurrentSign();
  }

  void _setValueInCell({
    required CellValue value,
    required int columnIndex,
    required int rowIndex,
  }) {
    setState(() {
      _values[columnIndex][rowIndex] = value;
    });
  }

  void _swapCurrentSign() {
    setState(() {
      _currentSign = switch (_currentSign) {
        CellValue.cross => CellValue.zero,
        CellValue.zero => CellValue.cross,
        _ => CellValue.cross,
      };
    });
  }

  Future<void> _showResetDialog() async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Начать игру сначала?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                _reset();

                Navigator.pop(context);
              },
              child: const Text('Да'),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Нет'),
            ),
          ],
        );
      },
    );
  }

  void _reset() {
    setState(() {
      _values = [
        List.filled(3, CellValue.none),
        List.filled(3, CellValue.none),
        List.filled(3, CellValue.none),
      ];

      _currentSign = CellValue.cross;
    });
  }
}
