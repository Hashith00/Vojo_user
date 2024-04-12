import 'dart:convert';
import 'package:http/http.dart' as http;


class ConvertPlaceId{
  static Future<Map<String, double>> getLatLngFromPlaceId(String placeId) async {
    final apiKey = 'AIzaSyC8XOXvvxImxyxY6dFnOKIMTlbOM3X58Yw'; // Replace with your Google Places API key
    final url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final double lat = data['result']['geometry']['location']['lat'];
        final double lng = data['result']['geometry']['location']['lng'];
        return {'latitude': lat, 'longitude': lng};
      } else {
        throw Exception('Failed to fetch data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

}