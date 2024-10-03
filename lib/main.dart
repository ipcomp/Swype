import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/app.dart';

Future<void> main() async {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
