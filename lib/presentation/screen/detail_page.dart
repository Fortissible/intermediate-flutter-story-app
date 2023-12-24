import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page")
      ),
      body: Stack(
        children: [
          Center(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: _indonesiaLocation,
                  zoom: 4
              ),
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
            ),
          ),
          Center(
            child: Consumer<StoryProvider>(
              builder: (ctx, provider, _){
                if (provider.storyDetailState == StoryDetailState.loading){
                  return const Column(
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
                  );
                } else if (provider.storyDetailState == StoryDetailState.hasData){
                  return Padding(
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
                  );
                } else if (provider.storyDetailState == StoryDetailState.noData){
                  return const Text(
                    "No data found...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  );
                } else if (provider.storyDetailState == StoryDetailState.error){
                  return Text(
                    "Error...\n${provider.errorMsg}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.deepOrangeAccent),
                  );
                } else {
                  return const Column(
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
                  );
                }
              },
            ),
          )
        ]
      )
    );
  }
}