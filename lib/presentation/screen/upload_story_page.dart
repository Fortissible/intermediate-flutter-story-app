import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intermediate_flutter_story_app/domain/entity/login_entity.dart';
import 'package:intermediate_flutter_story_app/presentation/provider/story_provider.dart';
import 'package:provider/provider.dart';

import 'camera_page.dart';

class UploadStoryPage extends StatefulWidget{
  final Function(bool) isBackToFeedsPage;
  final LoginEntity userLoginEntity;
  const UploadStoryPage({
    super.key,
    required this.isBackToFeedsPage,
    required this.userLoginEntity
  });

  @override
  State<UploadStoryPage> createState() => _UploadStoryPageState();
}

class _UploadStoryPageState extends State<UploadStoryPage> {
  String? _desc;

  @override
  void initState() {
    super.initState();
    final storyProvider = context.read<StoryProvider>();
    storyProvider.setUploadInitState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Project"),
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
        child: ListView(
            padding: const EdgeInsets.only(top:64),
            children: [
              SizedBox(
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
              SizedBox(
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
              ),
              const SizedBox(height: 16,),
              const Text(
                "Describe your post story:",
                style: TextStyle(
                    color: Colors.deepOrangeAccent
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top:16,left:32,right:32),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your description...',
                    ),
                    onChanged: (inputDesc){
                      setState(() {
                        _desc = inputDesc;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
              Consumer<StoryProvider>(
                builder: (ctx, provider, _){
                  if (provider.uploadStoryState == UploadStoryState.loading){
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Please wait...",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.deepOrangeAccent),
                          ),
                          CircularProgressIndicator(
                              color: Colors.deepOrangeAccent
                          )
                        ],
                      ),
                    );
                  } else if (provider.uploadStoryState == UploadStoryState.error){
                    _showSnackbar(provider.errorMsg);
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8,left:32,right:32
                      ),
                      child: Container(
                        height: 60.0,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(100)
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFF44F2B), Color(0xFFFF9D88)])
                        ),
                        child: TextButton(
                          onPressed: (){
                            _onUpload(provider);
                          },
                          child: const Text(
                            'Upload Story',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (provider.uploadStoryState == UploadStoryState.hasData){
                    provider.getListStory(widget.userLoginEntity.token);
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8,left:32,right:32
                      ),
                      child: Container(
                        height: 60.0,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(100)
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFF44F2B), Color(0xFFFF9D88)])
                        ),
                        child: TextButton(
                          onPressed: (){
                            _onUpload(provider);
                          },
                          child: const Text(
                            'Upload Story',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8,left:32,right:32
                      ),
                      child: Container(
                        height: 60.0,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(100)
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFF44F2B), Color(0xFFFF9D88)])
                        ),
                        child: TextButton(
                          onPressed: (){
                            _onUpload(provider);
                          },
                          child: const Text(
                            'Upload Story',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              )
            ]
        )
      ),
    );
  }

  _onUpload(StoryProvider provider) async {
    final imagePath = provider.imagePath;
    final imageFile = provider.imageFile;
    if (imagePath == null || imageFile == null || _desc == null) {
      final ScaffoldMessengerState scaffoldMessengerState =
      ScaffoldMessenger.of(context);
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please insert your story pics and fill the description!")),
      );

      return;
    }
    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await provider.compressImage(bytes);
    await provider.postStory(
      widget.userLoginEntity.token,
      _desc!,
      newBytes,
      fileName,
    );
  }

  Future _showSnackbar(String? msg) async {
    final ScaffoldMessengerState scaffoldMessengerState =
    ScaffoldMessenger.of(context);
    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text("Failed to upload story\n$msg!")),
    );
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
    ) : Container(
      height: 250,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99)
      ),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          //set border radius more than 50% of height and width to make circle
        ),
        color: const Color(0xFFC7C7C7),
        semanticContainer: true,
        child: Image.file(
          File(imagePath.toString()),
          fit: BoxFit.fill,
        ),
      )
    );
  }
}