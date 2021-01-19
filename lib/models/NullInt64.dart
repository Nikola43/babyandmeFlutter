class NullInt64 {
  int int64;
  bool valid;

  NullInt64({
    this.int64,
    this.valid,
  });

  NullInt64.fromJsonMap(Map<String, dynamic> json) {
    int64 = json['int64'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() => {
        'int64': int64,
        'valid': valid,
      };
}
