import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:{{appName.snakeCase()}}/domain/entity/login_entity.dart';
import 'package:{{appName.snakeCase()}}/presentation/provider/story_provider.dart';
import 'package:provider/provider.dart';

class UploadStoryPage extends StatefulWidget{
  final Function() isBackToFeedsPage;
  final Function() goToCameraPage;
  final LoginEntity userLoginEntity;
  const UploadStoryPage({
    super.key,
    required this.isBackToFeedsPage,
    required this.userLoginEntity,
    required this.goToCameraPage
  });

  @override
  State<UploadStoryPage> createState() => _UploadStoryPageState();
}

class _UploadStoryPageState extends State<UploadStoryPage> {
  String? _desc;
  bool? _isLocation = false;
  bool _isCustomLocation = false;
  final LatLng _indonesiaLocation = const LatLng(-7.4294398,109.8589577);
  late GoogleMapController mapController;
  LatLng? _customStoryLocation;
  late final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
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
                  widget.isBackToFeedsPage();
                },
              ),
            ),
          )
      ),
      body: SafeArea(
          child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.35,
                  child: Center(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition (
                          target: _indonesiaLocation,
                          zoom: 6
                      ),
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                        });
                      },
                      onLongPress: (LatLng latLng) {
                        setState(() {
                          _isCustomLocation = true;
                        });
                        onSetMarker(latLng, _isCustomLocation);
                      },
                      markers: markers,
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Use your current location : ",
                      style: TextStyle(
                          color: Colors.deepOrangeAccent
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Checkbox(
                        value: _isLocation,
                        onChanged: (value){
                          setState(() {
                            markers.clear();
                            _isLocation = value;
                            _isCustomLocation = false;
                          });
                          if (value==null || value==false){
                            setState(() {
                              markers.clear();
                            });
                            _showSnackbar("GPS Location Unselected!");
                          } else {
                            Future.microtask(
                                    () async {
                                  final locationPermission = await context.read<StoryProvider>().askLocationPermission();
                                  if (!locationPermission){
                                    setState(() {
                                      _isLocation = false;
                                    });
                                  } else {
                                    _showSnackbar("Location selected based on GPS");

                                    Position? userCurrentLocation;
                                    userCurrentLocation = await _determinePosition();

                                    setState(() {
                                      _customStoryLocation = userCurrentLocation != null
                                          ? LatLng(
                                          userCurrentLocation.latitude,
                                          userCurrentLocation.longitude
                                      )
                                          : null;
                                    });

                                    _customStoryLocation != null
                                        ? onSetMarker(
                                        LatLng(
                                            userCurrentLocation.latitude,
                                            userCurrentLocation.longitude
                                        ),
                                        _isCustomLocation
                                    )
                                        : null;
                                  }
                                }
                            );
                          }
                        }
                    ),
                  ],
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
                              "{{loadingMsg}}",
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
                      WidgetsBinding.instance.addPostFrameCallback((_) => _showSnackbar("Sukses upload story"));
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
                ),
                const SizedBox(height: 16,),
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
        markers.isEmpty
            ? null
            : LatLng(
            markers.first.position.latitude,
            markers.first.position.longitude
        )
    );
  }

  void _showSnackbar(String? msg) async {
    final ScaffoldMessengerState scaffoldMessengerState =
    ScaffoldMessenger.of(context);
    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(msg ?? "{{errorMsg}} uploading story")),
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
    final cameras = await availableCameras();
    final provider = context.read<StoryProvider>();
    provider.setListCameraDescription(cameras);
    widget.goToCameraPage();
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

  void onSetMarker(LatLng latLng, bool isCustomLocation) async {
    final info = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude
    );
    final place = info[0];
    final street = place.street ?? "Di suatu lokasi";
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    final marker = Marker(
        markerId: const MarkerId("source"),
        position: latLng,
        infoWindow: InfoWindow(
            title: "Story Location: $street",
            snippet: address
        )
    );

    setState(() {
      markers.clear();
      markers.add(marker);
      isCustomLocation
          ? _isLocation = false
          : null;
    });

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 13),
    );
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }
}