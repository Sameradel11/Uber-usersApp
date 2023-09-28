class AutoCompleteModel {
  final String description;
  final String secondarytext;
  final String placid;

  AutoCompleteModel(
      {required this.description,
      required this.secondarytext,
      required this.placid});

  factory AutoCompleteModel.fromjson(jsondata) {
    return AutoCompleteModel(
        description: jsondata["description"],
        secondarytext: jsondata["structured_formatting"]["secondary_text"],
        placid: jsondata['place_id']);
  }
}
