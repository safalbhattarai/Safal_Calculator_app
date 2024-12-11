import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _textController = TextEditingController();
  List<String> lstSymbols = [
    "C",
    "<",
    "/",
    "*",
    "7",
    "8",
    "9",
    "-",
    "4",
    "5",
    "6",
    "+",
    "1",
    "2",
    "3",
    "%",
    "0",
    ".",
    "=",
  ];

  /// Function to evaluate the mathematical expression manually
  double _calculate(String expression) {
    try {
      // Clean the expression and replace '%' with division by 100
      expression = expression.replaceAll('%', '/100');
      List<String> operators = ['+', '-', '*', '/'];
      List<String> numbers = [];
      List<String> ops = [];
      String currentNum = '';

      // Parse numbers and operators from the expression
      for (int i = 0; i < expression.length; i++) {
        String char = expression[i];
        if (operators.contains(char)) {
          if (currentNum.isNotEmpty) {
            numbers.add(currentNum);
            currentNum = '';
          }
          ops.add(char);
        } else {
          currentNum += char;
        }
      }
      if (currentNum.isNotEmpty) {
        numbers.add(currentNum);
      }

      // Perform multiplication and division first
      for (int i = 0; i < ops.length; i++) {
        if (ops[i] == '*' || ops[i] == '/') {
          double num1 = double.parse(numbers[i]);
          double num2 = double.parse(numbers[i + 1]);
          if (ops[i] == '*') {
            numbers[i] = (num1 * num2).toString();
          } else if (ops[i] == '/') {
            if (num2 != 0) {
              numbers[i] = (num1 / num2).toString();
            } else {
              throw Exception('Division by zero');
            }
          }
          numbers.removeAt(i + 1);
          ops.removeAt(i);
          i--;
        }
      }

      // Perform addition and subtraction
      double result = double.parse(numbers[0]);
      for (int i = 0; i < ops.length; i++) {
        double num = double.parse(numbers[i + 1]);
        if (ops[i] == '+') {
          result += num;
        } else if (ops[i] == '-') {
          result -= num;
        }
      }

      return result;
    } catch (e) {
      return double.nan; // Return NaN if there's an error
    }
  }

  void _onButtonPressed(String symbol) {
    setState(() {
      if (symbol == "C") {
        _textController.text = "";
      } else if (symbol == "<") {
        if (_textController.text.isNotEmpty) {
          _textController.text =
              _textController.text.substring(0, _textController.text.length - 1);
        }
      } else if (symbol == "=") {
        double result = _calculate(_textController.text);
        if (result.isNaN) {
          _textController.text = "Error";
        } else {
          _textController.text = result.toString();
        }
      } else {
        _textController.text += symbol;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safal Bhattarai Calculator App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              textDirection: TextDirection.rtl,
              controller: _textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              readOnly: true,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: lstSymbols.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () => _onButtonPressed(lstSymbols[index]),
                    child: Text(
                      lstSymbols[index],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}















