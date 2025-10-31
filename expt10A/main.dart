import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// NOTE:
// To run this app you MUST add platform firebase config files:
// - Android: android/app/google-services.json
// - iOS: GoogleService-Info.plist
//
// See README.md in the project root for setup steps.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator Firestore',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '';
  String _expression = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _numClick(String text) {
    setState(() {
      _display += text;
    });
  }

  void _clear() {
    setState(() {
      _display = '';
      _expression = '';
    });
  }

  void _delete() {
    if (_display.isNotEmpty) {
      setState(() {
        _display = _display.substring(0, _display.length - 1);
      });
    }
  }

  void _allOperators(String op) {
    if (_display.isEmpty) return;
    setState(() {
      _display += op;
    });
  }

  void _calculate() {
    try {
      // Very simple expression evaluator supporting + - * / and integers/doubles.
      final expr = _display.replaceAll('×', '*').replaceAll('÷', '/');
      final result = _evaluateExpression(expr);
      final resStr = result.toString();
      setState(() {
        _expression = '$_display = $resStr';
        _display = resStr;
      });
      // Save to Firestore
      _firestore.collection('calculations').add({
        'expression': expr,
        'result': resStr,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error evaluating expression: \$e')),
      );
    }
  }

  double _evaluateExpression(String expr) {
    // This is a simple shunting-yard + RPN evaluator for + - * / and parentheses.
    final outputQueue = <String>[];
    final opStack = <String>[];

    int i = 0;
    String readNumber() {
      final sb = StringBuffer();
      while (i < expr.length && (RegExp(r'[0-9\.]').hasMatch(expr[i]))) {
        sb.write(expr[i]);
        i++;
      }
      return sb.toString();
    }

    String? peekOp() => opStack.isNotEmpty ? opStack.last : null;
    int prec(String op) {
      if (op == '+' || op == '-') return 1;
      if (op == '*' || op == '/') return 2;
      return 0;
    }

    while (i < expr.length) {
      final ch = expr[i];
      if (ch == ' ') { i++; continue; }
      if (RegExp(r'[0-9\.]').hasMatch(ch)) {
        final num = readNumber();
        outputQueue.add(num);
        continue;
      }
      if (ch == '(') {
        opStack.add(ch);
      } else if (ch == ')') {
        while (opStack.isNotEmpty && peekOp() != '(') {
          outputQueue.add(opStack.removeLast());
        }
        if (opStack.isNotEmpty && peekOp() == '(') opStack.removeLast();
      } else if ('+-*/'.contains(ch)) {
        while (opStack.isNotEmpty && prec(peekOp()!) >= prec(ch)) {
          outputQueue.add(opStack.removeLast());
        }
        opStack.add(ch);
      } else {
        throw FormatException('Unexpected character: \$ch');
      }
      i++;
    }

    while (opStack.isNotEmpty) {
      outputQueue.add(opStack.removeLast());
    }

    // Evaluate RPN
    final stack = <double>[];
    for (final token in outputQueue) {
      if (RegExp(r'^-?\d+(?:\.\d+)?\$').hasMatch(token)) {
        stack.add(double.parse(token));
      } else if ('+-*/'.contains(token)) {
        if (stack.length < 2) throw FormatException('Invalid expression');
        final b = stack.removeLast();
        final a = stack.removeLast();
        double res;
        switch (token) {
          case '+': res = a + b; break;
          case '-': res = a - b; break;
          case '*': res = a * b; break;
          case '/': res = a / b; break;
          default: throw FormatException('Unknown operator');
        }
        stack.add(res);
      } else {
        throw FormatException('Unknown token: \$token');
      }
    }
    if (stack.length != 1) throw FormatException('Invalid evaluation');
    return stack.first;
  }

  Widget _buildButton(String text, {double flex = 1, VoidCallback? onTap}) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onTap ?? () => _numClick(text),
          child: Text(text, style: const TextStyle(fontSize: 24)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator — Firestore')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const Divider(),
          // Buttons
          Expanded(
            flex: 0,
            child: Column(
              children: [
                Row(children: [
                  _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('÷', onTap: () => _allOperators('/')),
                ]),
                Row(children: [
                  _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('×', onTap: () => _allOperators('*')),
                ]),
                Row(children: [
                  _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-', onTap: () => _allOperators('-')),
                ]),
                Row(children: [
                  _buildButton('0', flex: 2), _buildButton('.'), _buildButton('+', onTap: () => _allOperators('+')),
                ]),
                Row(children: [
                  _buildButton('C', onTap: _clear),
                  _buildButton('⌫', onTap: _delete),
                  _buildButton('=', onTap: _calculate),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          // History from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('calculations').orderBy('timestamp', descending: true).limit(50).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('Error loading history'));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) return const Center(child: Text('No history yet'));
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final d = docs[index].data() as Map<String, dynamic>;
                    final expr = d['expression']?.toString() ?? '';
                    final res = d['result']?.toString() ?? '';
                    final ts = d['timestamp'];
                    return ListTile(
                      title: Text('\$expr = \$res'),
                      subtitle: Text(ts?.toDate().toString() ?? ''),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
