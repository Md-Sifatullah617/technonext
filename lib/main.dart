import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:technonext/features/splash/presentation/splash_screen.dart';
import 'package:technonext/gen/colors.gen.dart';

import 'features/dashboard/data/services/location_service_impl.dart';
import 'features/dashboard/presentation/providers/location_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(LocationServiceImpl()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TechnoNext Assignment',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.scaffoldColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
