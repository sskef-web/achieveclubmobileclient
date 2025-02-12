class LoginResponse {
  String token;
  String userId;
  String refreshToken;
  String response;

  LoginResponse(this.token, this.userId, this.refreshToken, this.response);
}