import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intermediate_flutter_story_app/presentation/provider/story_provider.dart';
import 'package:provider/provider.dart';

import 'camera_page.dart';

class UploadStoryPage extends StatefulWidget{
  final Function(bool) isBackToFeedsPage;
  const UploadStoryPage({
    super.key,
    required this.isBackToFeedsPage
  });

  @override
  State<UploadStoryPage> createState() => _UploadStoryPageState();
}

class _UploadStoryPageState extends State<UploadStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Project"),
        actions: [
          IconButton(
            onPressed: () => _onUpload(),
            icon: const Icon(Icons.upload),
            tooltip: "Unggah",
          ),
        ],
        leading: Padding(
            padding: const EdgeInsets.only(
                left: 12
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color(0xFFDBDBDB),
                ),
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
                onPressed: () {
                  widget.isBackToFeedsPage(true);
                },
              ),
            ),
          )
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: context.watch<StoryProvider>().imagePath == null
                  ? const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.image,
                  size: 100,
                ),
              )
                  : _showImage(),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _onGalleryView(),
                    child: const Text("Gallery"),
                  ),
                  ElevatedButton(
                    onPressed: () => _onCameraView(),
                    child: const Text("Camera"),
                  ),
                  ElevatedButton(
                    onPressed: () => _onCustomCameraView(),
                    child: const Text("Custom Camera"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _onUpload() async {

  }

  _onGalleryView() async {
    final ImagePicker picker = ImagePicker();
    final provider = context.read<StoryProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;

    if (isMacOS || isLinux) return;

    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery
    );

    if (pickedFile != null){
      provider.setImagePath(pickedFile.path);
      provider.setImageFile(pickedFile);
    }
  }

  _onCameraView() async {
    final ImagePicker picker = ImagePicker();
    final provider = context.read<StoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
    );

    if (pickedFile != null){
      provider.setImagePath(pickedFile.path);
      provider.setImageFile(pickedFile);
    }
  }

  _onCustomCameraView() async {
    final provider = context.read<StoryProvider>();
    final navigator = Navigator.of(context);
    final cameras = await availableCameras();
    final XFile? resultImageFile = await navigator.push(
        MaterialPageRoute(
            builder: (context) => CameraPage(
                cameras : cameras
            )
        )
    );

    if (resultImageFile != null) {
      provider.setImageFile(resultImageFile);
      provider.setImagePath(resultImageFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<StoryProvider>().imagePath;
    return kIsWeb ? Image.network(
      imagePath.toString(),
      fit: BoxFit.contain,
    ) : Image.file(
      File(imagePath.toString()),
      fit: BoxFit.contain,
    );
  }
}