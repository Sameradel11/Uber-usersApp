class AutoCompleteModel {
  final String description;
  final String secondarytext;
  final String placid;
  final String maintext;

  AutoCompleteModel(
      {required this.maintext,
      required this.description,
      required this.secondarytext,
      required this.placid});

  factory AutoCompleteModel.fromjson(jsondata) {
    return AutoCompleteModel(
        description: jsondata["description"],
        secondarytext: jsondata["structured_formatting"]["secondary_text"],
        placid: jsondata['place_id'],
        maintext: jsondata['structured_formatting']['main_text']);
  }
}
