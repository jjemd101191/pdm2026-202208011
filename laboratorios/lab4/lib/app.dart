import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'theme.dart';

class TaskuApp extends StatelessWidget {
  const TaskuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskU · Lab 4',
      theme: buildTaskuTheme(),
      home: const HomeShell(),
    );
  }
}
