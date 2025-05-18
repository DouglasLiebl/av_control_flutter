import 'dart:convert';

class LoginDto {
  
  static encodeAuth(String email, String password) {
    return base64Encode(utf8.encode('$email:$password'));
  }
}
