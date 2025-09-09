class Login {
  String phone;
  String otp;

  Login({required this.phone, required this.otp});

  factory Login.fromJson(Map<String, dynamic> json) =>
      Login(phone: json['mobileNumber'], otp: json['otp']);

  Map<String, dynamic> toJson() =>
      {"mobileNumber": int.parse(phone), "otp": int.parse(otp)};
}

class SendOtp {
  String phone;

  SendOtp({required this.phone});

  factory SendOtp.fromJson(Map<String, dynamic> json) =>
      SendOtp(phone: json['mobileNumber']);

  Map<String, dynamic> toJson() => {
        "mobileNumber": phone,
      };
}

class NewUserModel {
  String firstName;
  String lastName;
  String dob;
  String email;
  String country;
  String city;

  NewUserModel(
      {required this.firstName,
      required this.lastName,
      required this.dob,
      required this.email,
      required this.country,
      required this.city});

  factory NewUserModel.fromJson(Map<String, dynamic> json) => NewUserModel(
      firstName: json["firstName"],
      lastName: json["lastName"],
      dob: json["dateOfBirth"],
      email: json["email"],
      country: json["country"],
      city: json["city"]);

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName" : lastName,
    "dateOfBirth" : dob,
    "email" : email,
    "country" : country,
    "city" : city
  };
}

class DashboardModel {
  final String firstName;
  final String lastName;
  final String dob;
  final String email;
  final String city;
  final String country;

  DashboardModel({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.email,
    required this.city,
    required this.country,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      dob: json["dateOfBirth"] ?? "",
      email: json["email"] ?? "",
      city: json["city"] ?? "",
      country: json["country"] ?? "",
    );
  }
}


