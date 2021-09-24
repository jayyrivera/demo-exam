class Location {
  List<Data>? data;
  String? status;

  Location({this.data, this.status});

  Location.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? code;
  String? mobileNum;
  String? area;
  String? province;
  String? city;
  String? name;
  String? businessName;
  String? address;
  String? lat;
  String? lng;
  String? type;
  int? depotId;
  int? dealerId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.code,
      this.mobileNum,
      this.area,
      this.province,
      this.city,
      this.name,
      this.businessName,
      this.address,
      this.lat,
      this.lng,
      this.type,
      this.depotId,
      this.dealerId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    mobileNum = json['mobileNum'];
    area = json['area'];
    province = json['province'];
    city = json['city'];
    name = json['name'];
    businessName = json['businessName'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    type = json['type'];
    depotId = json['depotId'];
    dealerId = json['dealerId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['code'] = this.code;
    data['mobileNum'] = this.mobileNum;
    data['area'] = this.area;
    data['province'] = this.province;
    data['city'] = this.city;
    data['name'] = this.name;
    data['businessName'] = this.businessName;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['type'] = this.type;
    data['depotId'] = this.depotId;
    data['dealerId'] = this.dealerId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
