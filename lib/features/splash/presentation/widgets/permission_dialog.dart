import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

/// Widget for handling permission denied scenarios
class PermissionDialog extends StatelessWidget {
  final String message;
  final VoidCallback onContinueAnyway;
  final VoidCallback? onOpenSettings;
  final bool isDeniedForever;

  const PermissionDialog({
    super.key,
    required this.message,
    required this.onContinueAnyway,
    this.onOpenSettings,
    this.isDeniedForever = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Icon(Icons.location_off, color: Colors.orange, size: 24.w),
          SizedBox(width: 8.w),
          Text(
            'Permission Required',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(message, style: TextStyle(fontSize: 14.sp, height: 1.4)),
      actions: [
        TextButton(
          onPressed: onContinueAnyway,
          child: Text(
            'Continue Anyway',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ),
        if (isDeniedForever && onOpenSettings != null)
          ElevatedButton(
            onPressed: onOpenSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Open Settings', style: TextStyle(fontSize: 14.sp)),
          ),
      ],
    );
  }

  /// Static method to show the dialog
  static Future<void> show({
    required BuildContext context,
    required String message,
    required VoidCallback onContinueAnyway,
    VoidCallback? onOpenSettings,
    bool isDeniedForever = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDialog(
        message: message,
        onContinueAnyway: onContinueAnyway,
        onOpenSettings:
            onOpenSettings ??
            (isDeniedForever ? () => Geolocator.openAppSettings() : null),
        isDeniedForever: isDeniedForever,
      ),
    );
  }
}
