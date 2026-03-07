import 'dart:async';
import 'package:flutter/material.dart';
import 'result_page.dart';

class GeneratingPage extends StatefulWidget {
  final String? imageName;
  final String? audioName;
  final String? videoName;
  final String userType;

  const GeneratingPage({
    super.key,
    required this.imageName,
    required this.audioName,
    required this.videoName,
    required this.userType,
  });

  @override
  State<GeneratingPage> createState() => _GeneratingPageState();
}

class _GeneratingPageState extends State<GeneratingPage> {
  int currentStep = 0;

  final List<String> steps = [
    'Reading uploaded media',
    'Mapping voice and visual context',
    'Generating educational scene flow',
    'Rendering final output video',
  ];

  @override
  void initState() {
    super.initState();
    startGeneration();
  }

  Future<void> startGeneration() async {
    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        currentStep = i;
      });
    }

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          imageName: widget.imageName,
          audioName: widget.audioName,
          videoName: widget.videoName,
          userType: widget.userType,
        ),
      ),
    );
  }

  Widget buildStep(int index) {
    final isDone = index <= currentStep;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFE8F0FE) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? const Color(0xFF4285F4) : const Color(0xFFE8EAED),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                isDone ? const Color(0xFF4285F4) : const Color(0xFFF1F3F4),
            child: Icon(
              isDone ? Icons.check : Icons.schedule,
              size: 18,
              color: isDone ? Colors.white : const Color(0xFF5F6368),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              steps[index],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDone ? const Color(0xFF202124) : const Color(0xFF5F6368),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / steps.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Generating Video')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFE8EAED)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    size: 70,
                    color: Color(0xFF4285F4),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Creating your academic AI video',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF202124),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please wait while the system processes your uploaded media and prepares the final lesson video.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFE8EAED),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF34A853)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(steps.length, buildStep),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}