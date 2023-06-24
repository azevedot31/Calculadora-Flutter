class Memory {
  static final operations = ['%', '/', '+', '-', '*', '='];

  late String _operation;
  bool _usedOperation = false;
  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  String result = '0';
  late String _expression;

  Memory() {
    _operation = '';
    _clear();
  }

  void _clear() {
    result = '0';
    _buffer.setAll(0, [0.0, 0.0]);
    _bufferIndex = 0;
    _operation = '';
    _usedOperation = false;
    _expression = '';
  }

  void applyCommand(String command) {
    if (command == 'AC') {
      _clear();
    } else if (command == 'DEL') {
      deleteEndDigit();
    } else if (operations.contains(command)) {
      _setOperation(command);
    } else {
      _addDigit(command);
    }
    result = _expression.isNotEmpty ? _expression : result;
  }

  void deleteEndDigit() {
    if (result.length > 1) {
      result = result.substring(0, result.length - 1);
      _expression = _expression.substring(0, _expression.length - 1);
    } else {
      result = '0';
      _expression = '';
    }
  }

  void _addDigit(String digit) {
    if (_usedOperation) {
      result = '0';
      _usedOperation = false;
    }
    if (result.contains('.') && digit == '.') {
      return;
    }
    if (result == '0' && digit != '.') {
      result = '';
      _expression = '';
    }
    result += digit;
    _expression += digit;
  }

  void _setOperation(String operation) {
    if (_bufferIndex == 0) {
      _buffer[0] = double.tryParse(result) ?? 0.0;
      _bufferIndex = 1;
    } else {
      _buffer[1] = double.tryParse(result) ?? 0.0;
      _buffer[0] = _calculate();
    }

    if (operation == '=') {
      result = _buffer[0].toString();
      result = result.endsWith('.0') ? result.split('.')[0] : result;
      _bufferIndex = 0;
      _expression = '';
    } else {
      result = '0';
      _bufferIndex = 1;
      _operation = operation;
      _usedOperation = true;
      _expression += operation;
    }
  }

  double _calculate() {
    switch (_operation) {
      case '%':
        return _buffer[0] * (_buffer[1] / 100);
      case '/':
        return _buffer[0] / _buffer[1];
      case '*':
        return _buffer[0] * _buffer[1];
      case '+':
        return _buffer[0] + _buffer[1];
      case '-':
        return _buffer[0] - _buffer[1];
      default:
        return 0.0;
    }
  }
}
  