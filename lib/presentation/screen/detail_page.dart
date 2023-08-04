import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intermediate_flutter_story_app/domain/entity/story_detail_entity.dart';

class DetailPage extends StatelessWidget{
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Page"),
        leading: Icon(Icons.person),
        actions: [
          Icon(Icons.add)
        ],
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (ctx, idx){
            return Card();
          }
      ),
    );
  }

}