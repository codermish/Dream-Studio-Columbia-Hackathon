import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ResultPage extends StatefulWidget {
  final String? imageName;
  final String? audioName;
  final String? videoName;
  final String userType;

  const ResultPage({
    super.key,
    required this.imageName,
    required this.audioName,
    required this.videoName,
    required this.userType,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late VideoPlayerController controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/videos/mock_lesson.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          isReady = true;
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> downloadVideoDetails() async {
    final payload = {
      'userType': widget.userType,
      'image': widget.imageName,
      'audio': widget.audioName,
      'video': widget.videoName,
      'generatedAt': DateTime.now().toIso8601String(),
    };

    final jsonText = jsonEncode(payload);
    debugPrint(jsonText);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video metadata prepared successfully.'),
      ),
    );
  }

  Widget buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Video'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFE8EAED)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your AI educational video is ready',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF202124),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Preview the generated output below.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF5F6368),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.black,
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: isReady ? controller.value.aspectRatio : 16 / 9,
                            child: isReady
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VideoPlayer(controller),
                                      IconButton(
                                        iconSize: 72,
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            if (controller.value.isPlaying) {
                                              controller.pause();
                                            } else {
                                              controller.play();
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          controller.value.isPlaying
                                              ? Icons.pause_circle_filled
                                              : Icons.play_circle_fill,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF4285F4),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          buildTag(
                            widget.imageName != null
                                ? 'Image: ${widget.imageName}'
                                : 'No image uploaded',
                            const Color(0xFF4285F4),
                          ),
                          buildTag(
                            widget.audioName != null
                                ? 'Audio: ${widget.audioName}'
                                : 'No audio uploaded',
                            const Color(0xFFEA4335),
                          ),
                          buildTag(
                            widget.videoName != null
                                ? 'Video: ${widget.videoName}'
                                : 'No video uploaded',
                            const Color(0xFFFBBC05),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: downloadVideoDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF34A853),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.download_rounded),
                          label: const Text(
                            'Download Metadata',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}