import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrogo/presentation/pages/home_page.dart';
import 'package:gastrogo/presentation/providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: GastroGoApp()));
}

class GastroGoApp extends ConsumerWidget {
  const GastroGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'GastroGo',
      debugShowCheckedModeBanner: false,
      themeMode: mode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFF5C00),
          secondary: Color(0xFFFFE6D5),
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
