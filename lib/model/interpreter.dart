class Interpreter {
  String? id;
  String? fullName;
  String? email;
  bool? active;
  bool? requestCall;

  Interpreter({
    required this.id,
    required this.fullName,
    required this.email,
    required this.active,
    required this.requestCall,
  });

  Interpreter.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    fullName = map['full_name'];
    email = map['email'];
    active = map['active'];
    requestCall = map['request_call'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'active': active,
      'request_call': requestCall,
    };
  }
}
