import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List workouts = [];
  bool loading = false;
  String error = '';

  Future<void> fetchWorkouts() async {
    setState(() {
      loading = true;
      error = '';
    });

    try {
      final client = HttpClient();
      final request = await client.getUrl(
        Uri.parse('http://localhost:3000/workouts'),
      );
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      client.close();

      if (response.statusCode == 200) {
        setState(() {
          workouts = jsonDecode(responseBody);
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load workouts';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Connection error: $e';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = neoPrimaryTextColor(context);
    final subTextColor = neoSecondaryTextColor(context);
    final accentColor = neoAccentColor(context);
    final cardColor = neoSurfaceColor(context);

    if (loading) {
      return Center(
        child: CircularProgressIndicator(color: accentColor),
      );
    }

    if (error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: neoShadows(context),
            ),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.error,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    if (workouts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: neoShadows(context),
            ),
            child: Text(
              'No workouts yet',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchWorkouts,
      color: accentColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: neoShadows(context),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                      boxShadow: neoShadows(context, distance: 5, blur: 10),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout['exercise'].toString(),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Weight: ${workout['weight']} | Reps: ${workout['reps']}',
                          style: TextStyle(
                            color: subTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}