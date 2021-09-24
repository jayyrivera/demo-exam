class Login {
  Data? data;
  String? status;

  Login({this.data, this.status});

  Login.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  int? id;
  String? accessToken;
  String? refreshToken;
  int? userId;
  String? expiresAt;
  String? updatedAt;
  String? createdAt;
  String? userUuid;
  String? message;

  Data(
      {this.id,
      this.accessToken,
      this.refreshToken,
      this.userId,
      this.expiresAt,
      this.updatedAt,
      this.createdAt,
      this.userUuid,
      this.message});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    userId = json['userId'];
    expiresAt = json['expiresAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    userUuid = json['userUuid'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['userId'] = userId;
    data['expiresAt'] = expiresAt;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    data['userUuid'] = userUuid;
    data['message'] = message;
    return data;
  }
}
