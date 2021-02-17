import 'package:babyandme/models/NullInt64.dart';
import 'package:babyandme/models/NullString.dart';

/*

	statement := fmt.Sprintf(
		"INSERT INTO users (clinic_id, username, password, name, lastname, phone, rol, available, updated_at, created_at) "+
			"VALUES('%d', '%s', '%s', '%s', '%s', '%s', '%s', '%d', '%s', '%s')",
		o.ClinicID.Int64, strings.ToLower(o.Username), hashAndSalt([]byte("babyandme")), o.Name.String, o.LastName.String, o.Phone.String, o.Rol, 1, date, date)
	res, err := db.Exec(statement)
 */

class SignUp {
  NullInt64 clinic_id;
  String username;
  String password;
  NullString name;
  NullString lastname;
  NullString phone;
  String rol;
  int week;
  int available;

  SignUp({
    this.clinic_id,
    this.username,
    this.password,
    this.name,
    this.lastname,
    this.phone,
    this.rol,
    this.week,
    this.available,
  });

  SignUp.fromJsonMap(Map<String, dynamic> json) {
    clinic_id = NullInt64.fromJsonMap(json['clinic_id']);
    username = json['username'];
    password = json['password'];
    name = NullString.fromJsonMap(json['name']);
    lastname = NullString.fromJsonMap(json['name']);
    phone = NullString.fromJsonMap(json['name']);
    rol = json['rol'];
    week = json['week'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() => {
        'clinic_id': clinic_id.toJson(),
        'username': username,
        'password': password,
        'name': name.toJson(),
        'lastname': lastname.toJson(),
        'phone': phone.toJson(),
        'rol': rol,
        'week': week,
        'available': available,
      };
}
