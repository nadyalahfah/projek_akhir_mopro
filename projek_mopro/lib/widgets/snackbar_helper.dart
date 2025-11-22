import 'package:flutter/material.dart';
import '../utils/constants.dart';

void showSuccessSnackbar(BuildContext ctx, String m) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(child: Text(m))
      ]),
      backgroundColor: successColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

void showErrorSnackbar(BuildContext ctx, String m) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Row(children: [
        const Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(child: Text(m))
      ]),
      backgroundColor: dangerColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

void showConfirmDialog(BuildContext ctx, String t, String c, VoidCallback ok) {
  showDialog(
    context: ctx,
    builder: (x) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(c),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(x),
          child: const Text("Batal", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: dangerColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Navigator.pop(x);
            ok();
          },
          child: const Text("Ya"),
        )
      ],
    ),
  );
}
