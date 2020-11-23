import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:chat_app/models/ad_location.dart';

class GoogleMapScreen extends StatefulWidget {
  final AdLocation placeLocation;
  final bool isEditable;

  GoogleMapScreen({
    this.placeLocation,
    this.isEditable,
  });

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  LatLng pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      pickedLocation = position;
    });
  }

  Set<Marker> get getMarker {
    if (pickedLocation == null && widget.isEditable) {
      return null;
    } else if (!widget.isEditable) {
      return {
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(
            widget.placeLocation.latitude,
            widget.placeLocation.longitude,
          ),
        )
      };
    } else {
      return {
        Marker(
          markerId: MarkerId('id'),
          position: pickedLocation,
        )
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.isEditable ? Text('Pick location') : Text('User location'),
        actions: widget.isEditable && pickedLocation != null
            ? [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => Navigator.of(context).pop(pickedLocation),
                ),
              ]
            : [],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.placeLocation.latitude,
            widget.placeLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isEditable ? _selectLocation : null,
        markers: getMarker,
      ),
    );
  }
}
