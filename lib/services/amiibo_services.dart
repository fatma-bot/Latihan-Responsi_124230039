import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latres/models/amiibo_model.dart';
import 'package:latres/models/release_model.dart';

class AmiiboService {
  final String baseUrl = "https://www.amiiboapi.com/api/amiibo";

  Future<List<AmiiboModel>> fetchAmiiboData() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final amiiboData = result['amiibo'];

      List<AmiiboModel> listAmiiboModel = [];
      for (var amiibo in amiiboData) {
        AmiiboModel amiiboModel = AmiiboModel(
          amiiboSeries: amiibo['amiiboSeries'],
          character: amiibo['character'],
          gameSeries: amiibo['gameSeries'],
          head: amiibo['head'],
          image: amiibo['image'],
          name: amiibo['name'],
          release: ReleaseModel.fromJson(amiibo['release']),
          tail: amiibo['tail'],
          type: amiibo['type'],
        );
        listAmiiboModel.add(amiiboModel);
      }
      return listAmiiboModel;
    }
    return [];
  }
}
