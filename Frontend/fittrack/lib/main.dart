import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'neo_widgets.dart';
import 'history_page.dart';
import 'progress_page.dart';
import 'workout_page.dart';

void main() {
  runApp(const FitTrackApp());
}

class FitTrackApp extends StatefulWidget {
  const FitTrackApp({super.key});

  @override
  State<FitTrackApp> createState() => _FitTrackAppState();
}

class _FitTrackAppState extends State<FitTrackApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      debugShowCheckedModeBanner: false,
      theme: getTheme(Brightness.light, const Color(0xFF4D7CFE)),
      darkTheme: getTheme(Brightness.dark, const Color(0xFF8FB4FF)),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    WorkoutPage(),
    HistoryPage(),
    ProgressPage(),
  ];

  Widget buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: selected
            ? NeoNavSelected(
                key: ValueKey('selected_$index'),
                icon: icon,
                label: label,
              )
            : NeoNavUnselected(
                key: ValueKey('unselected_$index'),
                icon: icon,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = neoIsDark(context);

    final toggleBg = isDark
        ? const Color(0xFF31415E)
        : const Color(0xFFD4E2FF);

    final toggleFg = isDark
        ? const Color(0xFFEAF2FF)
        : const Color(0xFF1F3F8F);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FitTrack',
          style: TextStyle(
            color: neoPrimaryTextColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton.filledTonal(
              onPressed: () {
                widget.onThemeChanged(!widget.isDarkMode);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(toggleBg),
                foregroundColor: WidgetStatePropertyAll(toggleFg),
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                surfaceTintColor:
                    const WidgetStatePropertyAll(Colors.transparent),
                shape: const WidgetStatePropertyAll(CircleBorder()),
              ),
              icon: Icon(
                widget.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
            ),
          ),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: NeoSurface(
          height: 92,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          radius: 30,
          shadows: neoShadows(context, distance: 10, blur: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(
                index: 0,
                icon: Icons.fitness_center,
                label: 'Workout',
              ),
              buildNavItem(
                index: 1,
                icon: Icons.history,
                label: 'History',
              ),
              buildNavItem(
                index: 2,
                icon: Icons.show_chart,
                label: 'Progress',
              ),
            ],
          ),
        ),
      ),
    );
  }
}