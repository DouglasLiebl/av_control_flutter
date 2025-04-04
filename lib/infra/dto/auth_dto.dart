class AuthDto {

  String accountId;
  String accessToken;
  String tokenType;
  String refreshToken;
  String accessTokenExpiration;

  AuthDto({
    required this.accountId,
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.accessTokenExpiration
  });

  factory AuthDto.fromJson(Map<String, dynamic> json) {
    return AuthDto(
      accountId: json['accountId'],
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
      refreshToken: json['refreshToken'],
      accessTokenExpiration: json['accessTokenExpiration']
    );
  }

  static Map<String, dynamic> toJson(AuthDto source) {
    return {
      "accountId": source.accountId,
      "accessToken": source.accessToken,
      "tokenType": source.tokenType,
      "refreshToken": source.refreshToken,
      "accessTokenExpiration": source.accessTokenExpiration
    };
  }
}