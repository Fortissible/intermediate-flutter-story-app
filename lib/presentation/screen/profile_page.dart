import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget{
  final Function(bool) isBackToFeedsPage;
  final Function(bool) loggingOut;
  const ProfilePage({
    super.key,
    required this.isBackToFeedsPage,
    required this.loggingOut
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Profile"),
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
      body: Padding(
        padding: const EdgeInsets.only(
            left: 32,
            right: 32,
            top:128
        ),
        child: SafeArea(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.loggingOut(true);
                },
                child: const Text("Logout"),
              ),
            )
        )
      ),
    );
  }
}