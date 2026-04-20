import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_theme.dart';

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

      request.write(
        jsonEncode({
          'exercise': normalizedExercise,
          'weight': weight,
          'reps': reps,
        }),
      );

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

  Widget buildNeoTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: neoSurfaceColor(context),
        borderRadius: BorderRadius.circular(22),
        boxShadow: neoShadows(context),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: scheme.primary),
          labelText: label,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
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
    final scheme = Theme.of(context).colorScheme;
    final textColor = neoPrimaryTextColor(context);
    final subTextColor = neoSecondaryTextColor(context);
    final accentColor = neoAccentColor(context);
    final cardColor = neoSurfaceColor(context);

    final bool isSuccess = message.toLowerCase().contains('success');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: neoShadows(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Workout',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your exercise, weight, and reps',
                  style: TextStyle(
                    fontSize: 14,
                    color: subTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 22),
                buildNeoTextField(
                  context: context,
                  controller: exerciseController,
                  label: 'Exercise',
                  icon: Icons.fitness_center,
                ),
                const SizedBox(height: 16),
                buildNeoTextField(
                  context: context,
                  controller: weightController,
                  label: 'Weight',
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                buildNeoTextField(
                  context: context,
                  controller: repsController,
                  label: 'Reps',
                  icon: Icons.repeat,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        ...neoShadows(context, distance: 7, blur: 16),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: saveWorkout,
                      style:
                          ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: accentColor,
                            shadowColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).copyWith(
                            overlayColor: const WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                          ),
                      child: Text(
                        'Save Workout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: neoShadows(context, distance: 5, blur: 10),
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSuccess ? Colors.green.shade700 : scheme.error,
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
