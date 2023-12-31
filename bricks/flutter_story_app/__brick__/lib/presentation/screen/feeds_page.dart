import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/login_entity.dart';
import '../provider/story_provider.dart';

class FeedsPage extends StatefulWidget{
  final Function(String) onSelectedStory;
  final Function() isUploadStorySelected;
  final Function() isProfileSelected;
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
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels
          >= scrollController.position.maxScrollExtent
          && context.read<StoryProvider>().page != null
      ){
        _fetchListStory();
      }
    });

    Future.microtask(() async => _fetchListStory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("{{feedsPageTitle.titleCase()}}"),
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
                widget.isProfileSelected();
              },
            ),
          ),
        ),
        actions: [
          GestureDetector(
              onTap: (){
                widget.isUploadStorySelected();
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
          if (provider.listStoryState == ListStoryState.loading){
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
          } else if (provider.listStoryState == ListStoryState.hasData) {
            final currentStoriesLength = provider.listStoryEntity?.length?? 0;
            return RefreshIndicator(
                onRefresh: () async {
                  _refreshListStory();
                },
                child: ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: currentStoriesLength + (provider.page != null ? 1 : 0),
                    itemBuilder: (ctx, idx){
                      if (idx == currentStoriesLength && provider.page != null){
                        return Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Color(0xFFF44F2B),
                                  ),
                                  const SizedBox(width: 8,),
                                  Text(
                                      "{{loadingMsg}}",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: const Color(0xFFF44F2B),
                                          fontWeight: FontWeight.normal
                                      )
                                  ),
                                ],
                              )
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: (){
                          widget.onSelectedStory(provider.listStoryEntity![idx].id);
                        },
                        child: Card(
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Image.network(provider.listStoryEntity?[idx].photoUrl??""),
                              Text(provider.listStoryEntity?[idx].name??"")
                            ],
                          ),
                        ),
                      );
                    }
                )
            );
          } else if (provider.listStoryState == ListStoryState.noData) {
            return const Center(
              child: Text(
                "{{dataEmptyMsg}}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            );
          } else if (provider.listStoryState == ListStoryState.error) {
            return Center(
              child: Text(
                provider.errorMsg ?? "{{errorMsg}}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.deepOrangeAccent),
              ),
            );
          } else {
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
      ),
    );
  }

  Future _fetchListStory() async {
    final storyProvider = context.read<StoryProvider>();
    await storyProvider.getListStory(widget.userLoginEntity.token
    );
  }

  Future _refreshListStory() async {
    final storyProvider = context.read<StoryProvider>();
    await storyProvider.refreshListStory(widget.userLoginEntity.token
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}