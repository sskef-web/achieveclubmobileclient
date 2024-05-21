import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FourDigitCodeInput extends StatefulWidget {
  final ValueChanged<String> updateProofCode;

  FourDigitCodeInput({super.key, required this.updateProofCode});

  @override
  _FourDigitCodeInputState createState() => _FourDigitCodeInputState();
}

class _FourDigitCodeInputState extends State<FourDigitCodeInput> {
  List<String> digitValues = List.generate(4, (_late ) => "");

  late List<FocusNode> digitFocusNodes;
  late List<TextEditingController> digitControllers;

  @override
  void initState() {
    super.initState();
    digitFocusNodes = List.generate(4, (_) => FocusNode());
    digitControllers = List.generate(4, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in digitControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            width: 50,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              controller: digitControllers[i],
              focusNode: digitFocusNodes[i],
              maxLength: 1,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                if (value.length == 1) {
                  if (i < 3) {
                    digitFocusNodes[i + 1].requestFocus();
                  } else {
                    digitFocusNodes[i].unfocus();
                  }
                }
                setState(() {
                  digitValues[i] = value;
                  widget.updateProofCode(digitValues.join(''));
                });
              },
            ),
          ),
      ],
    );
  }
}