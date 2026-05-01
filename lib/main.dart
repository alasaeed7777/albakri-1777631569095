```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  double _secondOperand = 0;
  String _operator = '';
  bool _isOperatorPressed = false;
  bool _isResultDisplayed = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_isResultDisplayed) {
        _display = number;
        _expression = '';
        _isResultDisplayed = false;
        _operator = '';
        _firstOperand = 0;
        _secondOperand = 0;
      } else if (_isOperatorPressed) {
        _display = number;
        _isOperatorPressed = false;
      } else {
        if (_display == '0' && number != '.') {
          _display = number;
        } else {
          _display += number;
        }
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (_operator.isNotEmpty && !_isOperatorPressed) {
        _calculateResult();
      }
      _firstOperand = double.parse(_display);
      _operator = operator;
      _isOperatorPressed = true;
      _isResultDisplayed = false;
      _expression = '$_firstOperand $_operator';
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (_isResultDisplayed) {
        _display = '0.';
        _expression = '';
        _isResultDisplayed = false;
        _operator = '';
        _firstOperand = 0;
        _secondOperand = 0;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _calculateResult() {
    _secondOperand = double.parse(_display);
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand + _secondOperand;
        break;
      case '-':
        result = _firstOperand - _secondOperand;
        break;
      case 'Ã':
        result = _firstOperand * _secondOperand;
        break;
      case 'Ã·':
        if (_secondOperand == 0) {
          _display = 'Ø®Ø·Ø£';
          _expression = '';
          _operator = '';
          _isResultDisplayed = true;
          return;
        }
        result = _firstOperand / _secondOperand;
        break;
      default:
        return;
    }

    String resultStr = result == result.truncateToDouble()
        ? result.toInt().toString()
        : result.toStringAsFixed(2);

    setState(() {
      _display = resultStr;
      _expression = '$_firstOperand $_operator $_secondOperand =';
      _operator = '';
      _isResultDisplayed = true;
    });
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0;
      _secondOperand = 0;
      _operator = '';
      _isOperatorPressed = false;
      _isResultDisplayed = false;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.isNotEmpty && _display != '0') {
        _display = _display.substring(0, _display.length - 1);
        if (_display.isEmpty) {
          _display = '0';
        }
      }
    });
  }

  void _onPercentagePressed() {
    setState(() {
      double current = double.parse(_display);
      double result = current / 100;
      _display = result == result.truncateToDouble()
          ? result.toInt().toString()
          : result.toStringAsFixed(4);
      _isResultDisplayed = true;
    });
  }

  void _onNegatePressed() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
    double flex = 1,
  }) {
    return Expanded(
      flex: flex.round(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 70,
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onPressed,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display area
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _display,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
          ),
          // Button grid
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Row 1: AC, +/- , %, Ã·
                  Row(
                    children: [
                      _buildButton(
                        text: 'AC',
                        color: colorScheme.secondaryContainer,
                        textColor: colorScheme.onSecondaryContainer,
                        onPressed: _onClearPressed,
                      ),
                      _buildButton(
                        text: '+/-',
                        color: colorScheme.secondaryContainer,
                        textColor: colorScheme.onSecondaryContainer,
                        onPressed: _onNegatePressed,
                      ),
                      _buildButton(
                        text: '%',
                        color: colorScheme.secondaryContainer,
                        textColor: colorScheme.onSecondaryContainer,
                        onPressed: _onPercentagePressed,
                      ),
                      _buildButton(
                        text: 'Ã·',
                        color: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                        onPressed: () => _onOperatorPressed('Ã·'),
                      ),
                    ],
                  ),
                  // Row 2: 7, 8, 9, Ã
                  Row(
                    children: [
                      _buildButton(
                        text: '7',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('7'),
                      ),
                      _buildButton(
                        text: '8',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('8'),
                      ),
                      _buildButton(
                        text: '9',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('9'),
                      ),
                      _buildButton(
                        text: 'Ã',
                        color: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                        onPressed: () => _onOperatorPressed('Ã'),
                      ),
                    ],
                  ),
                  // Row 3: 4, 5, 6, -
                  Row(
                    children: [
                      _buildButton(
                        text: '4',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('4'),
                      ),
                      _buildButton(
                        text: '5',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('5'),
                      ),
                      _buildButton(
                        text: '6',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('6'),
                      ),
                      _buildButton(
                        text: '-',
                        color: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                        onPressed: () => _onOperatorPressed('-'),
                      ),
                    ],
                  ),
                  // Row 4: 1, 2, 3, +
                  Row(
                    children: [
                      _buildButton(
                        text: '1',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('1'),
                      ),
                      _buildButton(
                        text: '2',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('2'),
                      ),
                      _buildButton(
                        text: '3',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('3'),
                      ),
                      _buildButton(
                        text: '+',
                        color: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                        onPressed: () => _onOperatorPressed('+'),
                      ),
                    ],
                  ),
                  // Row 5: 0 (double width), ., =
                  Row(
                    children: [
                      _buildButton(
                        text: '0',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: () => _onNumberPressed('0'),
                        flex: 2,
                      ),
                      _buildButton(
                        text: '.',
                        color: colorScheme.surfaceVariant,
                        textColor: colorScheme.onSurfaceVariant,
                        onPressed: _onDecimalPressed,
                      ),
                      _buildButton(
                        text: '=',
                        color: colorScheme.tertiary,
                        textColor: colorScheme.onTertiary,
                        onPressed: _calculateResult,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```