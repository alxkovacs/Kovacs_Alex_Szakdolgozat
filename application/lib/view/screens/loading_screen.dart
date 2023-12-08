import 'package:application/view/widgets/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomCircularProgressIndicator(),
    );
  }
}
