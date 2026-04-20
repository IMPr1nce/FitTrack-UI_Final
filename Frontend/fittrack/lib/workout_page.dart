import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'neo_widgets.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final TextEditingController exerciseController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  String message = '';

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

  Future<void> saveWorkout() async {
    final normalizedExercise = normalizeExercise(exerciseController.text);
    final weight = weightController.text.trim();
    final reps = repsController.text.trim();

    if (normalizedExercise.isEmpty || weight.isEmpty || reps.isEmpty) {
      setState(() {
        message = 'Please fill in all fields';
      });
      return;
    }

    try {
      final client = HttpClient();
      final request = await client.postUrl(
        Uri.parse('http://localhost:3000/workouts'),
      );

      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      request.write(jsonEncode({
        'exercise': normalizedExercise,
        'weight': weight,
        'reps': reps,
      }));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      client.close();

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          message = 'Workout saved successfully';
          exerciseController.clear();
          weightController.clear();
          repsController.clear();
        });
      } else {
        setState(() {
          message = 'Failed: $responseBody';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Connection error: $e';
      });
    }
  }

  @override
  void dispose() {
    exerciseController.dispose();
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = message.toLowerCase().contains('success');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          NeoSurface(
            padding: const EdgeInsets.all(22),
            radius: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Workout',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: neoPrimaryTextColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your exercise, weight, and reps',
                  style: TextStyle(
                    fontSize: 14,
                    color: neoSecondaryTextColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 22),
                NeoTextField(
                  controller: exerciseController,
                  label: 'Exercise',
                  icon: Icons.fitness_center,
                ),
                const SizedBox(height: 16),
                NeoTextField(
                  controller: weightController,
                  label: 'Weight',
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                NeoTextField(
                  controller: repsController,
                  label: 'Reps',
                  icon: Icons.repeat,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 22),
                NeoPrimaryButton(
                  text: 'Save Workout',
                  icon: Icons.save_rounded,
                  onPressed: saveWorkout,
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  NeoSurface(
                    padding: const EdgeInsets.all(14),
                    radius: 18,
                    shadows: neoShadows(context, distance: 5, blur: 10),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSuccess
                            ? Colors.green.shade700
                            : Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}