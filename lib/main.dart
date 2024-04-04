import 'package:flutter/material.dart';
import 'package:riv_auth_test/Features/Auth/SignIn/UI/signin_screen.dart';
import 'package:riv_auth_test/Features/Home/UI/home_screen.dart';
import 'package:riv_auth_test/Global/Style/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Features/Auth/Controller/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        final authState = ref.watch(authProvider);

        Widget getHome() {
          if (authState.status == AuthStatus.authenticated) {
            return const HomeScreen();
          } else {
            return const SignInScreen();
          }
        }

        return MaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: kMainColor),
            useMaterial3: true,
          ),
          home: getHome(),
        );
      },
    );
  }
}
