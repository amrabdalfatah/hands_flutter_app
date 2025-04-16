class Student {
  String? id;
  String? fullName;
  String? email;
  String? university;
  bool? active;

  Student({
    required this.id,
    required this.fullName,
    required this.email,
    required this.university,
    required this.active,
  });

  Student.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    fullName = map['full_name'];
    email = map['email'];
    university = map['university'];
    active = map['active'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'university': university,
      'active': active,
    };
  }
}
