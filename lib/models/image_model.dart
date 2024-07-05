// image_model.dart

class ImageModel {
  final int id;
  final String email;
  final String complexity;
  final String texture;
  final String color;
  final String imgurl;

  ImageModel({
    required this.id,
    required this.email,
    required this.complexity,
    required this.texture,
    required this.color,
    required this.imgurl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      email: json['email'],
      complexity: json['complexity'],
      texture: json['texture'],
      color: json['final_color'],
      imgurl: json['augmented_image'],
    );
  }
}
