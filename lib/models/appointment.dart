class Appointment {
  String name;
  String email;
  String phone;
  String promo_name;

  Appointment({
    this.name,
    this.email,
    this.phone,
    this.promo_name,
  });

  Appointment.fromJsonMap(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    promo_name = json['promo_name'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'promo_name': promo_name,
      };
}
