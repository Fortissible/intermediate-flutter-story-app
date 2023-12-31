import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class AuthPage extends StatefulWidget {
  final Function() isLoggedIn;
  final Function() isRegisterClicked;

  const AuthPage({
    super.key,
    required this.isLoggedIn,
    required this.isRegisterClicked
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 32,
                right: 32,
                top: 128
            ),
            child: ListView(
                children: [
                  Center(
                    child: Text(
                      "{{appName.titleCase()}}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.black
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8
                    ),
                    child: Text(
                        "Email",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email...',
                      ),
                      onChanged: (inputEmail){
                        setState(() {
                          _email = inputEmail;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8
                    ),
                    child: Text(
                        "Password",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password...',
                      ),
                      onChanged: (inputPassword){
                        setState(() {
                          _password = inputPassword;
                        });
                      },
                      obscureText: true,
                    ),
                  ),
                  context.watch<AuthProvider>().loginLoading ?
                  const Center(
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
                  ) : Padding(
                    padding: const EdgeInsets.only(
                        top: 8
                    ),
                    child: Container(
                      height: 44.0,
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
                          _loginUser();
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Doesn't have account?",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            widget.isRegisterClicked();
                          });
                        },
                        child: Text(
                          " Register Now",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black
                          ),
                        ),
                      )
                    ],
                  )
                ]
            ),
          )
      ),
    );
  }

  void _loginUser() async {
    final ScaffoldMessengerState scaffoldMessengerState =
    ScaffoldMessenger.of(context);
    final authProvider = context.read<AuthProvider>();
    if (_email == "" || _password == ""){
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please insert email and password!")),
      );
      return;
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email)){
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please enter valid email address!")),
      );
      return;
    } else if (_password.length < 8) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Password must contain minimal 8 character")),
      );
      return;
    } else if (_password.length >= 8){
      await authProvider.login(_email, _password);
    } else {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("{{loginInputCheckFailedMsg}}")),
      );
      return;
    }
    Provider.of<AuthProvider>(context, listen: false).errorMsg == null
        ? {
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text("Welcome ${authProvider.loginEntity?.name}!")),
      ),
      widget.isLoggedIn()
    } : scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(authProvider.errorMsg ?? "{{loginFailedMsg}}")),
    );

  }
}