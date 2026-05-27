import 'dart:async';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class TechnicianLiveTrackingScreen extends StatefulWidget {
  const TechnicianLiveTrackingScreen({super.key});

  @override
  State<TechnicianLiveTrackingScreen> createState() =>
      _TechnicianLiveTrackingScreenState();
}

class _TechnicianLiveTrackingScreenState
    extends State<TechnicianLiveTrackingScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  Location location = Location();

  LatLng userLocation = const LatLng(23.0225, 72.5714); // Ahmedabad Example
  LatLng technicianLocation =
  const LatLng(23.0300, 72.5800); // Technician Start Point

  Marker? technicianMarker;
  Marker? userMarker;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _startLiveTracking();
  }

  // ===================================================
  // ✅ Load Initial Markers
  // ===================================================
  void _loadMarkers() {
    userMarker = Marker(
      markerId: const MarkerId("user"),
      position: userLocation,
      infoWindow: const InfoWindow(title: "Your Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
    );

    technicianMarker = Marker(
      markerId: const MarkerId("technician"),
      position: technicianLocation,
      infoWindow: const InfoWindow(title: "Technician"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
  }

  // ===================================================
  // ✅ Simulate Technician Moving Live
  // (Later connect with Firebase Real Location)
  // ===================================================
  void _startLiveTracking() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      setState(() {
        technicianLocation = LatLng(
          technicianLocation.latitude + 0.0003,
          technicianLocation.longitude + 0.0003,
        );

        technicianMarker = technicianMarker!.copyWith(
          positionParam: technicianLocation,
        );
      });

      final GoogleMapController controller = await _mapController.future;

      controller.animateCamera(
        CameraUpdate.newLatLng(technicianLocation),
      );
    });
  }

  // ===================================================
  // ✅ UI Build
  // ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Live Technician Tracking",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // ===================================================
          // ✅ REAL GOOGLE MAP
          // ===================================================
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: technicianLocation,
                zoom: 14,
              ),
              markers: {
                if (userMarker != null) userMarker!,
                if (technicianMarker != null) technicianMarker!,
              },
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
            ),
          ),

          // ===================================================
          // ✅ Technician Bottom Info Card
          // ===================================================
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [

                Row(
                  children: const [
                    CircleAvatar(
                      radius: 26,
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Raj Patel • ⭐4.8",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.timer, color: Colors.orange),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Technician arriving in 15 minutes",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                  label: const Text("Call Technician"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}