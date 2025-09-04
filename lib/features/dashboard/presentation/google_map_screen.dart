import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:technonext/features/dashboard/presentation/providers/location_provider.dart';
import 'package:technonext/gen/colors.gen.dart';

class GoogleMapScreen extends StatelessWidget {
  GoogleMapScreen({super.key});
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void moveCameraToPosition(GoogleMapController controller, LatLng position) {
    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final myPosition = locationProvider.position;
        return Scaffold(
          body: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                myPosition?.latitude ?? 0,
                myPosition?.longitude ?? 0,
              ),
              zoom: 15,
            ),
            markers: {
              if (myPosition != null)
                Marker(
                  markerId: MarkerId('current_location'),
                  position: LatLng(myPosition.latitude, myPosition.longitude),
                ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              moveCameraToPosition(
                controller,
                LatLng(myPosition?.latitude ?? 0, myPosition?.longitude ?? 0),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: locationProvider.isLoading
                ? null
                : () async {
                    await locationProvider.fetchLocation();
                    final myPosition = locationProvider.position;
                    if (myPosition != null && _controller.isCompleted) {
                      _controller.future.then((controller) {
                        controller.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(myPosition.latitude, myPosition.longitude),
                          ),
                        );
                      });
                    }
                  },
            backgroundColor: AppColors.allPrimaryColor,
            child: locationProvider.isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.my_location),
          ),
        );
      },
    );
  }
}
