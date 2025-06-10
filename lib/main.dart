import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'package:to_do_app/features/model/task.dart';

import 'package:to_do_app/features/home.dart';
import 'package:to_do_app/features/theme_provider.dart';
import 'package:to_do_app/setting_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SettingModelAdapter());

  await Hive.openBox<Task>('tasks');
  await Hive.openBox<SettingModel>('setting');

  final themeProvider=ThemeProvider();
  await themeProvider.loadTheme();
  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: ThemeData.light(),
     darkTheme: ThemeData.dark(),
      themeMode: themeProvider.currentTheme,
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
