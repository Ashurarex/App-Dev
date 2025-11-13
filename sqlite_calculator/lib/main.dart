import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'db_helper.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = "0";

  void buttonPressed(String value) async {
    setState(() {
      if (value == "CLEAR") {
        output = "0";
      } else if (value == "⌫") {
        if (output.length > 1) {
          output = output.substring(0, output.length - 1);
        } else {
          output = "0";
        }
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(
            output.replaceAll("×", "*").replaceAll("÷", "/"),
          );
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          final result = eval.toString();
          final expr = output;
          output = result;
          // Save calculation in DB
          DBHelper.db.insertCalculation(Calculation(expression: expr, result: result));
        } catch (e) {
          output = "Error";
        }
      } else {
        if (output == "0") {
          output = value;
        } else {
          output += value;
        }
      }
    });
  }

  Widget buildButton(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () => buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void openHistoryScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HistoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: openHistoryScreen,
            tooltip: 'View Calculation History',
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.centerRight,
            child: Text(
              output,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Row(
            children: [
              buildButton("7", Colors.blue),
              buildButton("8", Colors.blue),
              buildButton("9", Colors.blue),
              buildButton("÷", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("4", Colors.blue),
              buildButton("5", Colors.blue),
              buildButton("6", Colors.blue),
              buildButton("×", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("1", Colors.blue),
              buildButton("2", Colors.blue),
              buildButton("3", Colors.blue),
              buildButton("-", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("0", Colors.blue),
              buildButton("00", Colors.blue),
              buildButton(".", Colors.blue),
              buildButton("+", Colors.orange),
            ],
          ),
          Row(
            children: [
              buildButton("CLEAR", Colors.red),
              buildButton("⌫", Colors.grey),
              buildButton("=", Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Calculation> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final calculations = await DBHelper.db.getAllCalculations();
    setState(() {
      history = calculations;
    });
  }

  Future<void> _clearHistory() async {
    await DBHelper.db.clearHistory();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculation History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History'),
                  content: const Text('Are you sure you want to clear all history?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        _clearHistory();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('No history found.'))
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final calc = history[index];
          return ListTile(
            title: Text('${calc.expression} = ${calc.result}'),
          );
        },
      ),
    );
  }
}
