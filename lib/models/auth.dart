class Auth {

  String accessToken;
  String tokenType;
  String refreshToken;
  String accessTokenExpiration;

  Auth({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.accessTokenExpiration
  });
}