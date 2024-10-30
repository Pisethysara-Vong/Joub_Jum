import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:joub_jum/consts.dart';
import 'package:joub_jum/components/location_list_tile.dart';
import 'package:joub_jum/components/network_util.dart';
import 'package:joub_jum/models/autocomplete_prediction.dart';
import 'package:joub_jum/models/place_auto_complete_response.dart';
import 'package:joub_jum/pages/map_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<AutocompletePrediction> placePrediction = [];

  Future<void> placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/place/autocomplete/json',
        {"input": query, "key": GOOGLE_MAP_API_KEY});
    String? response = await NetworkUtil.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePrediction = result.predictions!;
        });
      }
    }
  }

  Future<void> fetchPlaceDetails(String? placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$GOOGLE_MAP_API_KEY';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final placeDetails = json.decode(response.body)['result'];
      final lat = placeDetails['geometry']['location']['lat'];
      final lng = placeDetails['geometry']['location']['lng'];

      LatLng selectedLocation = LatLng(lat, lng);
      Navigator.pop(context, selectedLocation);

    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Row(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: placePrediction.length,
                itemBuilder: (context, index) => LocationListTile(
                    location: placePrediction[index].description!,
                    press: () {
                      fetchPlaceDetails(placePrediction[index].placeId);
                    }),
              ),
            ),
          ],
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
        // backgroundColor: appBarColor,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            height: 40.0, // Set the desired height here
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
              child: TextField(
                onChanged: (value) {
                  placeAutocomplete(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Search your location',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 15.0),
                textAlign: TextAlign.justify,
                autofocus: true,
              ),
            ),
          ),
        ));
  }
}
