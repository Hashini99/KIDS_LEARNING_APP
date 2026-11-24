import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Simple parent gate: asks a quick math question so a young child can't
/// stumble into Settings or the Stories module by accident.
class ParentGate {
  ParentGate._();

  static Future<bool> check(BuildContext context) async {
    final a = Random().nextInt(8) + 2;
    final b = Random().nextInt(8) + 2;
    final answer = a + b;
    final controller = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        String? error;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Parents Only', style: GoogleFonts.baloo2(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick check — what is $a + $b?'),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Answer',
                    errorText: error,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (int.tryParse(controller.text) == answer) {
                    Navigator.pop(dialogContext, true);
                  } else {
                    setState(() => error = 'Try again');
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }
}
