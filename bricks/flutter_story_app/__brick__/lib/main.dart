import 'package:flutter/material.dart';
import 'package:{{appName.snakeCase()}}/core/routes/router_delegate.dart';
import 'package:{{appName.snakeCase()}}/presentation/provider/auth_provider.dart';
import 'package:{{appName.snakeCase()}}/presentation/provider/story_provider.dart';
import 'package:provider/provider.dart';
import 'package:{{appName.snakeCase()}}/core/di/injection.dart' as di;

import 'core/di/injection.dart';
import 'core/sharedpreferences/user_shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await UserSharedPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;
  String? selectedStory;

  @override
  void initState() {
    super.initState();
    myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StoryProvider>(create:
            (ctx) => StoryProvider(repository: locator())
        ),
        ChangeNotifierProvider<AuthProvider>(create:
            (ctx) => AuthProvider(repository: locator())
        )
      ],
      child: MaterialApp(
          title: '{{appName.titleCase()}}',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
            useMaterial3: true,
          ),
          home: Router(
            routerDelegate: myRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          )
      ),
    );
  }
}