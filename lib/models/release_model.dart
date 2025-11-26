class ReleaseModel {
  final String? au;
  final String? eu;
  final String? jp;
  final String? na;

  ReleaseModel({this.au, this.eu, this.jp, this.na});

  factory ReleaseModel.fromJson(Map<String, dynamic> json) {
    return ReleaseModel(
      au: json['au'],
      eu: json['eu'],
      jp: json['jp'],
      na: json['na'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'au': au,
      'eu': eu,
      'jp': jp,
      'na': na,
    };
  }
}
