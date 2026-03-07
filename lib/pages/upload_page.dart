import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../widgets/file_upload_card.dart';
import 'generating_page.dart';

class UploadPage extends StatefulWidget {
  final String userType;

  const UploadPage({super.key, required this.userType});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? imageName;
  String? audioName;
  String? videoName;

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'webp'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => imageName = result.files.single.name);
    }
  }

  Future<void> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'aac'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => audioName = result.files.single.name);
    }
  }

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'avi', 'mkv'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => videoName = result.files.single.name);
    }
  }

  void generateVideo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GeneratingPage(
          imageName: imageName,
          audioName: audioName,
          videoName: videoName,
          userType: widget.userType,
        ),
      ),
    );
  }

  Widget buildTopCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF34A853)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Academic Media Composer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Build a teaching video from the media you provide.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Upload an image, an audio file, or a video reference. The system will use your content as the foundation for an AI-generated educational video.',
            style: TextStyle(
              color: Color(0xFFF1F3F4),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EAED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Logged in as: ${widget.userType}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Recommended flow:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5F6368),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '1. Upload a face or character image\n'
            '2. Upload narration audio if available\n'
            '3. Upload a reference video if you want movement/style guidance\n'
            '4. Generate your AI-powered educational video',
            style: TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Color(0xFF202124),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Educational Video'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTopCard(),
                const SizedBox(height: 24),
                buildInstructionCard(),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth > 900
                        ? (constraints.maxWidth - 32) / 3
                        : constraints.maxWidth;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        FileUploadCard(
                          width: cardWidth,
                          title: 'Image',
                          subtitle: 'Upload a face, teacher image, or avatar reference',
                          buttonText: 'Select Image',
                          fileName: imageName,
                          color: const Color(0xFF4285F4),
                          icon: Icons.image_rounded,
                          onTap: pickImage,
                        ),
                        FileUploadCard(
                          width: cardWidth,
                          title: 'Audio',
                          subtitle: 'Upload a narration or reference voice',
                          buttonText: 'Select Audio',
                          fileName: audioName,
                          color: const Color(0xFFEA4335),
                          icon: Icons.mic_rounded,
                          onTap: pickAudio,
                        ),
                        FileUploadCard(
                          width: cardWidth,
                          title: 'Video',
                          subtitle: 'Upload a motion or scene reference clip',
                          buttonText: 'Select Video',
                          fileName: videoName,
                          color: const Color(0xFFFBBC05),
                          icon: Icons.video_collection_rounded,
                          onTap: pickVideo,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: generateVideo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34A853),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Generate Video',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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