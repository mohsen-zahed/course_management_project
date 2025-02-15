class CardPartsModel {
  final String name;
  final String studentId;
  final int value;

  const CardPartsModel({required this.name, required this.studentId, required this.value});

  // factory CardPartsModel.fromJson(Map<String, dynamic> json) {
  //   return CardPartsModel(name: json[''], studentId: studentId, value: value)
  // }
}
