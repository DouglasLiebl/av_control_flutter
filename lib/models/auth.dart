class Auth {

  String accountId;
  String accessToken;
  String tokenType;
  String refreshToken;
  String accessTokenExpiration;

  Auth({
    required this.accountId,
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.accessTokenExpiration
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      accountId: json['accountId'],
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
      refreshToken: json['refreshToken'],
      accessTokenExpiration: json['accessTokenExpiration']
    );
  }
}