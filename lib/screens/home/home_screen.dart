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
  late List<CellValue> _values;

  CellValue _currentSign = CellValue.cross;
  CellValue? _winner;

  final List<List<int>> _winnerIndexes = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

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
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _values.length,
            itemBuilder: (context, index) {
              return CellButton(
                value: _values[index],
                onPressed: _cellHasValue(index)
                    ? null
                    : () {
                        _makeTurn(
                          value: _currentSign,
                          index: index,
                        );
                      },
                border: Border(
                  top: index < 3 ? BorderSide.none : const BorderSide(),
                  left: index == 0 ? BorderSide.none : const BorderSide(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool _cellHasValue(int index) {
    return _values[index] != CellValue.none;
  }

  void _makeTurn({
    required CellValue value,
    required int index,
  }) {
    _setValueInCell(
      value: value,
      index: index,
    );

    _swapCurrentSign();
    _setWinner();
    _showEndGameAlert();
  }

  void _setValueInCell({
    required CellValue value,
    required int index,
  }) {
    setState(() {
      _values[index] = value;
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

  Future<void> _showResetDialog({Widget? content}) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Начать игру сначала?'),
          content: content,
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
      _values = List.filled(9, CellValue.none);

      _currentSign = CellValue.cross;
    });
  }

  void _setWinner() {
    CellValue? winner;

    for (final indexes in _winnerIndexes) {
      final hasCrossWinner =
          _checkArrEveryValueIsTheSame(indexes, CellValue.cross);
      final hasZeroWinner =
          _checkArrEveryValueIsTheSame(indexes, CellValue.zero);

      if (hasZeroWinner || hasCrossWinner) {
        winner = _values[indexes.first];
      }
    }

    _winner = winner;
  }

  bool _checkArrEveryValueIsTheSame(List<int> arr, CellValue value) {
    return arr.fold(
        [], (prev, curr) => [...prev, _values[curr]]).every((e) => e == value);
  }

  void _showEndGameAlert() {
    if (_winner != null) {
      _showResetDialog(
          content: Text(
        '${_winner!.valueName} победили!',
      ));
    } else if (_winner == null && _values.every((e) => e != CellValue.none)) {
      _showResetDialog(
          content: const Text(
        'Ничья!',
      ));
    }
  }
}
