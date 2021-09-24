import 'package:dio/dio.dart';
import 'package:seaoil/models/location.dart';
import 'package:seaoil/models/login_model.dart';
import 'package:seaoil/utils/constants.dart';
import 'package:seaoil/utils/sharedprefs.dart';

class Api {
  var dio = Dio();

  Future<Login> login(
      {required String mobile, required String password}) async {
    try {
      var data = {'mobile': mobile, 'password': password};
      dio.options.connectTimeout = 25000;
      var response =
          await dio.post(Constants.url + 'mobile/v2/sessions', data: data);

      return Login.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Location> getLocationList() async {
    try {
      var token = await SharedPrefUtils.readPrefStr(Constants.token_key);
      dio.options.connectTimeout = 25000;
      dio.options.headers['Authorization'] = token;

      print(dio.options.headers);
      var response = await dio.get(Constants.url + 'mobile/stations?all');

      return Location.fromJson(response.data);
    } on DioError catch (e) {
      print(e);
      rethrow;
    }
  }
}
