// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  String expression = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void buttonPressed(String value) {
    setState(() {
      if (value == "CLEAR") {
        output = "0";
        expression = "";
      } else if (value == "⌫") {
        // Backspace
        if (output.length > 1) {
          output = output.substring(0, output.length - 1);
        } else {
          output = "0";
        }
      } else if (value == "=") {
        // Evaluate expression and save to Firebase
        try {
          String expressionToEvaluate = output.replaceAll("×", "*").replaceAll("÷", "/");
          Parser p = Parser();
          Expression exp = p.parse(expressionToEvaluate);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          String result = eval.toString();
          
          // Save calculation to Firebase
          _saveCalculation(expressionToEvaluate, result);
          
          output = result;
          expression = "";
        } catch (e) {
          output = "Error";
        }
      } else if (value == "±") {
        // Toggle sign
        if (output != "0" && output != "Error") {
          if (output.startsWith("-")) {
            output = output.substring(1);
          } else {
            output = "-$output";
          }
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

  Future<void> _saveCalculation(String expression, String result) async {
    try {
      await _firestore.collection('calculations').add({
        'expression': expression,
        'result': result,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle error silently in production
      debugPrint('Error saving calculation: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculator")),
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
              buildButton("±", Colors.grey),
              buildButton("=", Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}

