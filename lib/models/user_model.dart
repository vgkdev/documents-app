class UserModel {
  UserModel({
    this.success,
    this.error,
    this.message,
    this.data,
  });

  String? success;
  dynamic error;
  String? message;
  User? data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"],
        error: json["error"],
        message: json["message"],
        data: User.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error,
        "message": message,
        "data": data!.toJson(),
      };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
    this.photoPath,
  });

  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  dynamic photo;
  String? photoPath;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"].toString(),
        firstName: json["firstName"]?.toString() ?? '',
        lastName: json["lastName"]?.toString() ?? '',
        email: json["email"].toString(),
        phone: json["phone"].toString(),
        photo: json["photo"].toString(),
        photoPath: json["photo_path"]?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "photo": photo,
        "photo_path": photoPath,
      };
}
