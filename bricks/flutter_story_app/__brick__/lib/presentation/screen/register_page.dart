import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:{{appName.snakeCase()}}/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget{
  final Function() isSuccessfulyRegistered;
  const RegisterPage({
    Key? key,
    required this.isSuccessfulyRegistered
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? _email = "";
  String? _password = "";
  String? _name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register Page"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 48
          ),
          child: ListView(
            children: [
              Center(
                child: Text(
                  "{{appName.titleCase()}}\nRegister",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.black
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8
                ),
                child: Text(
                    "Name",
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
                    hintText: 'Enter your name...',
                  ),
                  onChanged: (inputName){
                    setState(() {
                      _name = inputName;
                    });
                  },
                ),
              ),
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
                    hintText: 'Enter your valid email...',
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
                    hintText: 'Enter password with minimum 8 char...',
                  ),
                  onChanged: (inputPassword){
                    setState(() {
                      _password = inputPassword;
                    });
                  },
                  obscureText: true,
                ),
              ),
              context.watch<AuthProvider>().registerLoading ?
              const Center(
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
                      _registerNewAccount();
                    },
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  void _registerNewAccount() async {
    final ScaffoldMessengerState scaffoldMessengerState =
    ScaffoldMessenger.of(context);
    final authProvider = context.read<AuthProvider>();
    if (_name == "" || _email == ""){
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please fill the form correctly!")),
      );
      return;
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email!)){
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Please enter valid email address!")),
      );
      return;
    } else if (_password!.length < 8) {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("Password must contain minimal 8 character")),
      );
      return;
    } else if (_password!.length >= 8){
      await authProvider.register(_name!, _email!, _password!);
    } else {
      scaffoldMessengerState.showSnackBar(
        const SnackBar(content: Text("{{registerInputCheckFailedMsg}}")),
      );
      return;
    }
    Provider.of<AuthProvider>(context, listen: false).errorMsg == null
        ? {
      scaffoldMessengerState.showSnackBar(
        SnackBar(content: Text(authProvider.responseMsg ?? "Register Success")),
      ),
      widget.isSuccessfulyRegistered()
    } : scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(authProvider.errorMsg ?? "Register Failed")),
    );
  }
}