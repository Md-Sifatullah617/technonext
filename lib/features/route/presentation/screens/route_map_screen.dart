import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../providers/route_provider.dart';
import '../widgets/route_info_widget.dart';
import '../widgets/route_status_widget.dart';

class RouteMapScreen extends StatefulWidget {
  const RouteMapScreen({super.key});

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  GoogleMapController? _mapController;

  // Default location (Dhaka, Bangladesh)
  static const LatLng _defaultLocation = LatLng(
    AppConfig.defaultLatitude,
    AppConfig.defaultLongitude,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Car Route Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<RouteProvider>(
            builder: (context, routeProvider, child) {
              return IconButton(
                onPressed:
                    routeProvider.origin != null ||
                        routeProvider.destination != null
                    ? () => routeProvider.clearRoute()
                    : null,
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear all',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          Consumer<RouteProvider>(
            builder: (context, routeProvider, child) {
              return GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                initialCameraPosition: const CameraPosition(
                  target: _defaultLocation,
                  zoom: AppConfig.defaultZoom,
                ),
                onTap: (LatLng position) {
                  routeProvider.handleMapTap(position);
                },
                markers: routeProvider.markers,
                polylines: routeProvider.polylines,
                mapType: routeProvider.mapType,
                zoomControlsEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                trafficEnabled: false,
              );
            },
          ),

          // Status Widget
          Positioned(top: 16.h, left: 16.w, child: const RouteStatusWidget()),

          // Route Info Widget
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: const RouteInfoWidget(),
          ),

          // Instructions
          Positioned(
            top: 20.h, // Moved down to avoid overlap with map type selector
            right: 16.w,
            child: Consumer<RouteProvider>(
              builder: (context, routeProvider, child) {
                if (routeProvider.origin == null &&
                    routeProvider.destination == null) {
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16.w,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Instructions:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        _buildInstructionRow(
                          '1. Tap to select origin',
                          Icons.location_on,
                          Colors.green,
                        ),
                        _buildInstructionRow(
                          '2. Tap to select destination',
                          Icons.location_on,
                          Colors.red,
                        ),
                        _buildInstructionRow(
                          '3. View optimal route',
                          Icons.directions,
                          Colors.blue,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<RouteProvider>(
        builder: (context, routeProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Map type selector FAB
              FloatingActionButton(
                mini: true,
                heroTag: "mapType",
                onPressed: () =>
                    _showMapTypeBottomSheet(context, routeProvider),
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                tooltip: 'Change map type',
                child: const Icon(Icons.layers),
              ),
              SizedBox(height: 8.h),

              // Fit bounds FAB (only show when route exists)
              if (routeProvider.origin != null &&
                  routeProvider.destination != null)
                FloatingActionButton(
                  heroTag: "fitBounds",
                  onPressed: () => _fitBounds(routeProvider),
                  backgroundColor: Colors.blue,
                  tooltip: 'Fit route to screen',
                  child: const Icon(
                    Icons.center_focus_strong,
                    color: Colors.white,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInstructionRow(String text, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Icon(icon, size: 12.w, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  void _fitBounds(RouteProvider routeProvider) {
    if (_mapController == null ||
        routeProvider.origin == null ||
        routeProvider.destination == null) {
      return;
    }

    final origin = routeProvider.origin!;
    final destination = routeProvider.destination!;

    final bounds = LatLngBounds(
      southwest: LatLng(
        origin.latitude < destination.latitude
            ? origin.latitude
            : destination.latitude,
        origin.longitude < destination.longitude
            ? origin.longitude
            : destination.longitude,
      ),
      northeast: LatLng(
        origin.latitude > destination.latitude
            ? origin.latitude
            : destination.latitude,
        origin.longitude > destination.longitude
            ? origin.longitude
            : destination.longitude,
      ),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  void _showMapTypeBottomSheet(
    BuildContext context,
    RouteProvider routeProvider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Map Type',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            for (final mapTypeInfo in routeProvider.getAvailableMapTypes()) ...[
              Builder(
                builder: (context) {
                  final isSelected = routeProvider.mapType == mapTypeInfo.type;

                  return ListTile(
                    leading: Icon(
                      mapTypeInfo.icon,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    title: Text(
                      mapTypeInfo.name,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      routeProvider.changeMapType(mapTypeInfo.type);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
