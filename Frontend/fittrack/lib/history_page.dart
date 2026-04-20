import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'neo_widgets.dart';

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

    if (workouts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: NeoSurface(
            padding: const EdgeInsets.all(20),
            child: Text(
              'No workouts yet',
              style: TextStyle(
                color: neoPrimaryTextColor(context),
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
      color: neoAccentColor(context),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];

          return NeoSurface(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const NeoIconTile(
                  icon: Icons.fitness_center,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout['exercise'].toString(),
                        style: TextStyle(
                          color: neoPrimaryTextColor(context),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Weight: ${workout['weight']} | Reps: ${workout['reps']}',
                        style: TextStyle(
                          color: neoSecondaryTextColor(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}