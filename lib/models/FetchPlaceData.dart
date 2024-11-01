import 'dart:convert';
import 'package:joub_jum/consts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


Future<List> fetchPlace(String? placeID) async {
  final String placeSearchURL =
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$GOOGLE_MAP_API_KEY';
  final response = await http.get(Uri.parse(placeSearchURL));

  if (response.statusCode == 200) {
    final placeDetails = json.decode(response.body)['result'];
    final lat = placeDetails['geometry']['location']['lat'];
    final lng = placeDetails['geometry']['location']['lng'];
    final photoReference = placeDetails['photos'][0]['photo_reference'];
    LatLng selectedLocation = LatLng(lat, lng);
    String photoData = getPlacePhotoData(photoReference);

    List<dynamic> locationAndPhotoData = [selectedLocation, photoData];
    return locationAndPhotoData;

  }
  else {
    throw Exception('Failed to load place details');
  }
}

String getPlacePhotoData(String? photoReference) {
  const maxHeight = 200;
  const maxWidth = 200;
  final String url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key=$GOOGLE_MAP_API_KEY";
  return url;
}