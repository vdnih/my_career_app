import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/timeline/presentation/timeline_screen.dart';

void main() {
  runApp(const ProviderScope(child: CareerTimelineApp()));
}

class CareerTimelineApp extends StatelessWidget {
  const CareerTimelineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Timeline',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const TimelineScreen(),
    );
  }
}
