class prediction {
  String? placeId;
  String? mainText;
  String? secondtypetext;

  prediction({
    this.mainText,
    this.placeId,
    this.secondtypetext,
  });

  prediction.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondtypetext = json['structured_formatting']['secondary_text'];
  }
}
