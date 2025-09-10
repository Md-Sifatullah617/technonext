import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:technonext/core/config/app_config.dart';
import 'package:technonext/core/di/service_locator.dart';
import 'package:technonext/features/route/presentation/providers/route_provider.dart';
import 'package:technonext/features/splash/presentation/providers/splash_provider.dart';
import 'package:technonext/features/splash/presentation/splash_screen.dart';
import 'package:technonext/gen/colors.gen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize configuration
  await AppConfig.initialize();

  // Setup all dependencies using GetIt
  await setupDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<RouteProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<SplashProvider>()),
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
        home: const SplashScreen(),
      ),
    );
  }
}
