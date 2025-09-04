import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:technonext/features/dashboard/presentation/google_map_screen.dart';
import 'package:technonext/features/dashboard/presentation/providers/location_provider.dart';
import 'package:technonext/gen/assets.gen.dart';
import 'package:technonext/gen/colors.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final locationProvider = Provider.of<LocationProvider>(
          context,
          listen: false,
        );
        await locationProvider.requestLocationPermission();
        if (locationProvider.permission == LocationPermission.deniedForever) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Permission Required'),
              content: Text(
                'Location permission is permanently denied. Please go to app settings and enable location permission.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Geolocator.openAppSettings(),
                  child: Text('Open Settings'),
                ),
              ],
            ),
          );
        } else if (locationProvider.permission == LocationPermission.always ||
            locationProvider.permission == LocationPermission.whileInUse) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GoogleMapScreen()),
          );
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => ClipRRect(
            child: Align(
              alignment: Alignment.center,
              widthFactor: _animation.value,
              child: Image.asset(Assets.images.technonextLogo.path),
            ),
          ),
        ),
      ),
    );
  }
}
