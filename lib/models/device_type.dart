class DeviceType {
  String string;
  bool valid;

  DeviceType({
    this.string,
    this.valid,
  });

  DeviceType.fromJsonMap(Map<String, dynamic> json) {
    string = json['string'];
    valid = json['valid'];
  }
}
