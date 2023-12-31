import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intermediate_flutter_story_app/core/utils/converter.dart';
import 'package:provider/provider.dart';

import '../provider/story_provider.dart';

class DetailPage extends StatefulWidget{
  final String storyId;
  final String token;

  const DetailPage({
    super.key,
    required this.storyId,
    required this.token
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final LatLng _indonesiaLocation = const LatLng(-2.44565, 117.8888);
  late GoogleMapController mapController;
  late Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page")
      ),
      body: Consumer<StoryProvider>(
        builder: (ctx, provider, _){
          if (provider.storyDetailState == StoryDetailState.loading){
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
                )
            );
          }
          else if (provider.storyDetailState == StoryDetailState.hasData){
            return ListView(
                children: [
                  provider.storyDetailEntity?.lat != null
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height*0.35,
                      child: Stack(
                        children: [
                          Center(
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition (
                                  target: _indonesiaLocation,
                                  zoom: 4
                              ),
                              markers: markers,
                              onMapCreated: (controller) {
                                setState(() {
                                  mapController = controller;
                                });
                                provider.storyDetailEntity?.lat != null
                                    ? _setStoryMarker(
                                        LatLng(
                                            provider.storyDetailEntity!.lat ?? 0,
                                            provider.storyDetailEntity!.lon ?? 0
                                        )
                                    )
                                    : null;
                              },
                            ),
                          ),
                          markers.isEmpty
                              ? Align (
                            alignment: Alignment.bottomCenter,
                            child: Padding (
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4)
                                    ),
                                    color: Color(0x99F44F2B)
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    "This story doesn't have location",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                              : const SizedBox()
                        ],
                      )
                  )
                  : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(16)
                            ),
                            color: Color(0x44F44F2B)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100)
                                ),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(provider.storyDetailEntity?.photoUrl ?? ""),
                                ),
                              ),
                              Text(
                                "By ${provider.storyDetailEntity?.name}",
                                style: const TextStyle(
                                    color: Colors.deepOrangeAccent
                                ),
                              ),
                              const SizedBox(height: 16,),
                              const Text(
                                "Description:",
                                style: TextStyle(
                                    color: Colors.deepOrangeAccent
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4,),
                              Text(
                                provider.storyDetailEntity?.description ?? "",
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4,),
                              Text(
                                convertDateTime(provider.storyDetailEntity?.createdAt.toString()),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                    ),
                  )
                ]
            );
          }
          else if (provider.storyDetailState == StoryDetailState.noData){
            return const Center(
              child: Text(
                "No data found...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            );
          }
          else if (provider.storyDetailState == StoryDetailState.error){
            return Center(
              child: Text(
                "Error...\n${provider.errorMsg}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.deepOrangeAccent),
              ),
            );
          }
          else {
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
          }
        },
      )
    );
  }

  void _setStoryMarker(LatLng latLng) async {

    final info = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude
    );
    final place = info[0];
    final street = place.street ?? "Di suatu lokasi";
    final address =
        '${place.subLocality}, ${place.country}';

    setState(() {
      markers.clear();
      markers.add(
          Marker(
            markerId: const MarkerId("source"),
            position: LatLng (
                latLng.latitude,
                latLng.longitude
            ),
            infoWindow: InfoWindow(
              title: street,
              snippet: address
            )
          )
      );
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
            latLng, 13
        ),
      );
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}