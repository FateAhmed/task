import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiring_task/firebase/FirebaseServices.dart';
import 'package:hiring_task/firebase_options.dart';
import 'package:hiring_task/provider/AuthManager.dart';
import 'package:hiring_task/router/Router.dart';
import 'package:hiring_task/utils/AppColors.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initLocalStorage();
  runApp(InitProviders());
}

class InitProviders extends StatelessWidget {
  InitProviders({super.key});
  final FirebaseStreamService firebaseStream = FirebaseStreamService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthManager(), lazy: false),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'Hiring Task',
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.backgroundSecondary,
              dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.background),
              canvasColor: Colors.white70,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AppColors.textPrimary),
                bodyMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                bodySmall: TextStyle(color: AppColors.textSecondary),
              ),
              appBarTheme: AppBarTheme(
                elevation: 3,
                centerTitle: true,
                backgroundColor: AppColors.background,
                surfaceTintColor: AppColors.background,
                titleTextStyle: const TextStyle(color: AppColors.textPrimary),
                iconTheme: const IconThemeData(color: AppColors.iconSecondary),
                shadowColor: AppColors.secondary.withOpacity(0.5),
              ),
            ),
            routerConfig: AppRouter.router,
          );
        });
  }
}
