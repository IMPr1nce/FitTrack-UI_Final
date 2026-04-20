import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'neo_widgets.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List workouts = [];
  bool loading = true;
  String error = '';

  int workoutsThisWeek = 0;
  double totalWeightLifted = 0;
  Map<String, double> personalRecords = {};

  @override
  void initState() {
    super.initState();
    fetchProgressData();
  }

  String normalizeExercise(String input) {
    String value = input.toLowerCase().trim();

    value = value.replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2');
    value = value.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ' ');
    value = value.replaceAll(RegExp(r'\s+'), ' ');

    final aliases = {
      'chestpress': 'chest press',
      'benchpress': 'bench press',
      'shoulderpress': 'shoulder press',
      'latpulldown': 'lat pulldown',
      'bicepcurl': 'bicep curl',
      'triceppushdown': 'tricep pushdown',
    };

    final noSpaces = value.replaceAll(' ', '');
    if (aliases.containsKey(noSpaces)) {
      return aliases[noSpaces]!;
    }

    return value;
  }

  String formatExercise(String name) {
    return name
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Future<void> fetchProgressData() async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(
        Uri.parse('http://localhost:3000/workouts'),
      );
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      client.close();

      if (response.statusCode == 200) {
        workouts = jsonDecode(responseBody);
        calculateProgress();
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load progress data';
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

  void calculateProgress() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    workoutsThisWeek = 0;
    totalWeightLifted = 0;
    personalRecords = {};

    for (final workout in workouts) {
      final exercise = normalizeExercise(workout['exercise'].toString());
      final weight = double.tryParse(workout['weight'].toString()) ?? 0;
      final reps = int.tryParse(workout['reps'].toString()) ?? 0;

      totalWeightLifted += weight * reps;

      final currentPR = personalRecords[exercise] ?? 0;
      if (weight > currentPR) {
        personalRecords[exercise] = weight;
      }

      if (workout['createdAt'] != null) {
        final createdAt = DateTime.tryParse(workout['createdAt']);
        if (createdAt != null && createdAt.isAfter(sevenDaysAgo)) {
          workoutsThisWeek++;
        }
      }
    }
  }

  Widget buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return NeoSurface(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          NeoIconTile(icon: icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: neoPrimaryTextColor(context),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: neoAccentColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPRCard(BuildContext context, String exercise, double weight) {
    return NeoSurface(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const NeoIconTile(icon: Icons.emoji_events),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              formatExercise(exercise),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: neoPrimaryTextColor(context),
              ),
            ),
          ),
          Text(
            '${weight.toStringAsFixed(0)} lbs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: neoAccentColor(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(
          color: neoAccentColor(context),
        ),
      );
    }

    if (error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: NeoSurface(
            padding: const EdgeInsets.all(20),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: neoAccentColor(context),
      onRefresh: fetchProgressData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          buildStatCard(
            context,
            'Workouts This Week',
            workoutsThisWeek.toString(),
            Icons.calendar_today,
          ),
          buildStatCard(
            context,
            'Total Weight Lifted',
            totalWeightLifted.toStringAsFixed(0),
            Icons.fitness_center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Personal Records',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: neoPrimaryTextColor(context),
              ),
            ),
          ),
          const SizedBox(height: 14),
          if (personalRecords.isEmpty)
            NeoSurface(
              padding: const EdgeInsets.all(18),
              child: Text(
                'No PR data yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: neoSecondaryTextColor(context),
                ),
              ),
            )
          else
            ...personalRecords.entries.map(
              (entry) => buildPRCard(context, entry.key, entry.value),
            ),
        ],
      ),
    );
  }
}