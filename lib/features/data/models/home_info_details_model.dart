class HomeInfoDetailsModel {
  final String label;
  final int value;
  final String imagePath;

  HomeInfoDetailsModel({required this.label, required this.value, required this.imagePath});

  // Convert JSON to DetailModel
  factory HomeInfoDetailsModel.fromJson(Map<String, dynamic> json) {
    return HomeInfoDetailsModel(
      label: json['label'],
      value: json['value'],
      imagePath: '',
    );
  }
  HomeInfoDetailsModel copyWith({
    String? label,
    int? value,
    String? imagePath,
  }) {
    return HomeInfoDetailsModel(
      label: label ?? this.label, // Use the provided value or keep the current one
      value: value ?? this.value, // Use the provided value or keep the current one
      imagePath: imagePath ?? this.imagePath, // Use the provided value or keep the current one
    );
  }

  // Convert DetailModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'image': imagePath,
    };
  }
}
