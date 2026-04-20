import 'package:flutter/material.dart';
import 'app_theme.dart';
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

  Widget buildRaisedNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) {
    final isDark = neoIsDark(context);
    final surface = neoSurfaceColor(context);
    final accent = neoAccentColor(context);
    final textColor = neoPrimaryTextColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.95),
            offset: const Offset(-6, -6),
            blurRadius: 12,
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.50)
                : const Color(0xFFA7B7D6).withOpacity(0.75),
            offset: const Offset(6, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 22),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUnselectedNavItem({
    required BuildContext context,
    required IconData icon,
  }) {
    final isDark = neoIsDark(context);
    final surface = neoSurfaceColor(context);
    final iconColor = isDark
        ? const Color(0xFFAEBBD1)
        : const Color(0xFF6B7C98);

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.95),
            offset: const Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.45)
                : const Color(0xFFA7B7D6).withOpacity(0.70),
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = neoIsDark(context);
    final panelColor = neoSurfaceColor(context);
    final titleColor = neoPrimaryTextColor(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FitTrack',
          style: TextStyle(
            color: titleColor,
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
                backgroundColor: WidgetStatePropertyAll(
                  isDark
                      ? const Color(0xFF31415E)
                      : const Color(0xFFD4E2FF),
                ),
                foregroundColor: WidgetStatePropertyAll(
                  isDark
                      ? const Color(0xFFEAF2FF)
                      : const Color(0xFF1F3F8F),
                ),
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
        child: Container(
          height: 92,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: panelColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.white.withOpacity(0.96),
                offset: const Offset(-12, -12),
                blurRadius: 22,
              ),
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.58)
                    : const Color(0xFFA7B7D6).withOpacity(0.85),
                offset: const Offset(12, 12),
                blurRadius: 22,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 0),
                child: selectedIndex == 0
                    ? buildRaisedNavItem(
                        context: context,
                        icon: Icons.fitness_center,
                        label: 'Workout',
                      )
                    : buildUnselectedNavItem(
                        context: context,
                        icon: Icons.fitness_center,
                      ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 1),
                child: selectedIndex == 1
                    ? buildRaisedNavItem(
                        context: context,
                        icon: Icons.history,
                        label: 'History',
                      )
                    : buildUnselectedNavItem(
                        context: context,
                        icon: Icons.history,
                      ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedIndex = 2),
                child: selectedIndex == 2
                    ? buildRaisedNavItem(
                        context: context,
                        icon: Icons.show_chart,
                        label: 'Progress',
                      )
                    : buildUnselectedNavItem(
                        context: context,
                        icon: Icons.show_chart,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}