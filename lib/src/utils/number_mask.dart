import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + ' ');
      if (newValue.selection.end >= 2) selectionIndex++;
    }

    if (newTextLength >= 6) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 5) + ' ');
      if (newValue.selection.end >= 5) selectionIndex++;
    }

    if (newTextLength >= 8) {
      newText.write(newValue.text.substring(5, usedSubstringIndex = 7) + ' ');
      if (newValue.selection.end >= 7) selectionIndex++;
    }

    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}