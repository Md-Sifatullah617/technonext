import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:technonext/features/route/presentation/screens/route_map_screen.dart';
import 'package:technonext/gen/assets.gen.dart';
import 'package:technonext/gen/colors.gen.dart';

import 'providers/splash_provider.dart';
import 'widgets/permission_dialog.dart';

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
    super.initState();
    _initializeAnimation();
    _initializeSplash();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _initializeSplash() {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    splashProvider.initializeSplash();
    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await splashProvider.checkLocationPermission();
      }
    });
  }

  void _navigateToMainScreen() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RouteMapScreen()),
    );
  }

  void _handlePermissionDeniedForever(SplashProvider provider) {
    PermissionDialog.show(
      context: context,
      message:
          provider.permissionStatus?.message ??
          'Location permission is permanently denied. Please enable it in app settings.',
      isDeniedForever: true,
      onContinueAnyway: _navigateToMainScreen,
      onOpenSettings: () {
        Navigator.pop(context); // Close dialog first
        _navigateToMainScreen(); // Then navigate
      },
    );
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
      body: Consumer<SplashProvider>(
        builder: (context, splashProvider, child) {
          // Handle state changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (splashProvider.state) {
              case SplashState.permissionGranted:
              case SplashState.permissionDenied:
              case SplashState.error:
                _navigateToMainScreen();
                break;
              case SplashState.permissionDeniedForever:
                _handlePermissionDeniedForever(splashProvider);
                break;
              default:
                break;
            }
          });

          return Stack(
            children: [
              // Main logo animation
              Center(
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

              // Loading indicator when checking permission
              if (splashProvider.isLoading)
                Positioned(
                  bottom: 100.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Checking permissions...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Error message if any
              if (splashProvider.state == SplashState.error &&
                  splashProvider.errorMessage != null)
                Positioned(
                  bottom: 100.h,
                  left: 20.w,
                  right: 20.w,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      splashProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.red[700]),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
