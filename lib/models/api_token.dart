class ApiToken {
  String accessToken;

  ApiToken({
    this.accessToken,
  });

  ApiToken.fromJsonMap(Map<String, dynamic> json) {
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
      };
}
