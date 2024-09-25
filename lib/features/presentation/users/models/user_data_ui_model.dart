
class UserDataUIModel {
  final String firebase_uid;
  final String display_name;
  final String email;
  final String first_name;
  final String last_name;
  final List days; 

  UserDataUIModel(
      {required this.firebase_uid,
      required this.display_name,
      required this.email,
      required this.first_name,
      required this.last_name,
      required this.days});

  factory UserDataUIModel.fromJson(Map<String, dynamic> json) => UserDataUIModel(
        firebase_uid: json["firebase_uid"],
        email: json["email"],
        display_name: json["display_name"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        days: json["days"],
      );
  Map<String, dynamic> toJson() => {
        "firebase_uid": firebase_uid,
        "email": email,
        "display_name": display_name,
        "first_name": first_name,
        "last_name": last_name,
        'days': days,
      };
}
