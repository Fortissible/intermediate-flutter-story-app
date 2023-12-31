import 'package:flutter/material.dart';
import 'package:{{appName.snakeCase()}}/core/sharedpreferences/user_shared_preferences.dart';

class ProfilePage extends StatefulWidget{
  final Function() isBackToFeedsPage;
  final Function() loggingOut;
  final String? username;
  const ProfilePage({
    super.key,
    required this.isBackToFeedsPage,
    required this.loggingOut,
    required this.username
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("${widget.username} Profile"),
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
                    UserSharedPreferences.logoutPrefs();
                    widget.loggingOut();
                  },
                  child: const Text("Logout"),
                ),
              )
          )
      ),
    );
  }
}