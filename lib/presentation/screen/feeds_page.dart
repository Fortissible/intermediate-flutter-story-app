import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/login_entity.dart';
import '../../domain/entity/story_entity.dart';
import '../provider/story_provider.dart';

class FeedsPage extends StatefulWidget{
  final Function(String) onSelectedStory;
  final Function(bool) isUploadStorySelected;
  final Function(bool) isProfileSelected;
  final LoginEntity userLoginEntity;

  const FeedsPage({
    Key? key,
    required this.onSelectedStory,
    required this.isUploadStorySelected,
    required this.isProfileSelected,
    required this.userLoginEntity
  }) : super(key: key);

  @override
  State<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {

  @override
  void initState() {
    super.initState();
    _fetchListStory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feeds Page"),
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
              icon: const Icon(
                  Icons.person,
                  color: Colors.black),
              onPressed: () {
                widget.isProfileSelected(true);
              },
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              widget.isUploadStorySelected(true);
            },
            child: Padding(
                padding: const EdgeInsets.only(right:16),
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: const Color(0xFFDBDBDB),
                      ),
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.black,
                            )
                          ],
                        )
                    )
                ),
              )
          )
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (ctx, provider, _){
          if (provider.state == ResultState.loading){
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
          } else if (provider.state == ResultState.hasData) {
            return RefreshIndicator(
                onRefresh: () async {
                  _fetchListStory();
                },
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.listStoryEntity?.length ?? 0,
                    itemBuilder: (ctx, idx){
                      return GestureDetector(
                        onTap: (){
                          widget.onSelectedStory(provider.listStoryEntity![idx].id);
                        },
                        child: Card(
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Image.network(provider.listStoryEntity![idx].photoUrl),
                              Text(provider.listStoryEntity![idx].name)
                            ],
                          ),
                        ),
                      );
                    }
                )
            );
          } else if (provider.state == ResultState.noData) {
            return const Center(
              child: Text(
                "There are no data to be displayed...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            );
          } else if (provider.state == ResultState.error) {
            return Center(
              child: Text(
                provider.errorMsg ?? "Error...",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.deepOrangeAccent),
              ),
            );
          } else {
            return const Center(
              child: Text(
                "Error...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            print(widget.userLoginEntity.token);
          },
          child: Icon(Icons.add),
      ),
    );
  }

  void _fetchListStory(){
    final authProvider = context.read<StoryProvider>();
    authProvider.getListStory(widget.userLoginEntity.token);
  }
}