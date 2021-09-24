import 'package:flutter/cupertino.dart';
import 'package:seaoil/services/api.dart';
import 'package:seaoil/utils/constants.dart';
import 'package:seaoil/utils/sharedprefs.dart';

class LoginNotifier extends ChangeNotifier {
  var api = Api();

  Future<dynamic> loginUser(
      {required String mobile, required String password}) async {
    var result = await api.login(mobile: mobile, password: password);
    print(result.toJson());
    if (result.status == 'success') {
      await SharedPrefUtils.saveStr(
          Constants.token_key, result.data!.accessToken!);
      await SharedPrefUtils.saveStr(
          Constants.refresh_token_key, result.data!.refreshToken!);

      return true;
    } else {
      return result.data?.message;
    }
  }
}
