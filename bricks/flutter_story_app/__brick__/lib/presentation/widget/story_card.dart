import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entity/detail_page_argument.dart';

class StoryCard extends StatelessWidget{
  final String imageUrl;
  final String username;
  final DetailPageArgument detailPageArgument;

  const StoryCard({
    super.key,
    required this.imageUrl,
    required this.detailPageArgument,
    required this.username
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // GO TO DETAIL PAGE
        },
        child: Wrap(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Card(
                  elevation: 4,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        imageUrl,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                              child: Image.asset("images/placeholder.jpg")
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  color: Colors.black54,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2
                            ),
                            child: Text(
                                username,
                                style: GoogleFonts.poppins(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white
                                )
                            ),
                          )
                      )
                  ),
                ),
              ],
            )
          ],
        )
    );
  }

}