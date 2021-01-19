class NullString {
  String string;
  bool valid;

  NullString({
    this.string,
    this.valid,
  });

  NullString.fromJsonMap(Map<String, dynamic> json) {
    string = json['string'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() => {
        'string': string,
        'valid': valid,
      };
}
