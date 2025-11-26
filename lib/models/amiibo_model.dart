import 'package:latres/models/release_model.dart';

class AmiiboModel {
  String amiiboSeries;
  String character;
  String gameSeries;
  String head;
  String image;
  String name;
  ReleaseModel release;
  String tail;
  String type;

  AmiiboModel({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.image,
    required this.name,
    required this.release,
    required this.tail,
    required this.type,
  });

  //JSON -> Object
  factory AmiiboModel.fromJson(Map<String, dynamic> json) {
    return AmiiboModel(
      name: json['name'] ?? '',
      amiiboSeries: json['amiiboSeries'] ?? '',
      character: json['character'] ?? '',
      gameSeries: json['gameSeries'] ?? '',
      head: json['head'] ?? '',
      tail: json['tail'] ?? '',
      type: json['type'] ?? '',
      image: json['image'] ?? '',
      release: ReleaseModel.fromJson(json['release'] ?? {}),
    );
  }

  //Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amiiboSeries': amiiboSeries,
      'character': character,
      'gameSeries': gameSeries,
      'head': head,
      'tail': tail,
      'type': type,
      'image': image,
      'release': release.toJson(),
    };
  }
}
