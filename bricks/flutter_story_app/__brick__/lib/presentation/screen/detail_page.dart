import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:{{appName.snakeCase()}}/core/utils/converter.dart';
import 'package:{{appName.snakeCase()}}/presentation/widget/event_snackbar.dart';
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
  late final Set<Marker> markers = {};

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
                        "{{loadingMsg}}",
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
                    SizedBox(
                        height: MediaQuery.of(context).size.height*0.35,
                        child: Stack(
                          children: [
                            Center(
                              child: GoogleMap(
                                initialCameraPosition: provider.storyDetailEntity?.lat == null
                                    ? CameraPosition (
                                    target: _indonesiaLocation,
                                    zoom: 4
                                )
                                    : CameraPosition (
                                    target: LatLng (
                                        provider.storyDetailEntity!.lat ?? 0,
                                        provider.storyDetailEntity!.lon ?? 0
                                    ),
                                    zoom: 16
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
                            provider.storyDetailEntity?.lat == null
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
                    ),
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
                                  height: 300,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
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
                  "{{dataEmptyMsg}}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              );
            }
            else if (provider.storyDetailState == StoryDetailState.error){
              return Center(
                child: Text(
                  "{{errorMsg}}\n${provider.errorMsg}",
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
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

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
          // onTap: () {
          //   _showSnackbar(
          //     LatLng(
          //         provider.storyDetailEntity!.lat ?? 0,
          //         provider.storyDetailEntity!.lon ?? 0
          //     )
          //   );
          // }
        )
    );
  }

  void _showSnackbar(LatLng latlng) async {

    final info =
    await placemarkFromCoordinates(
        latlng.latitude,
        latlng.longitude
    );
    final place = info[0];
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    EventSnackBar(
        context: context,
        content: address
    ).showSaveFilterSnackBar();
  }
}