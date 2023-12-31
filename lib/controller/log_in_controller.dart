import 'dart:convert';
import 'package:best_buy/token_shareprefe.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../pages/home_page.dart';
import '../token_shareprefe.dart';

class LogInController extends GetxController {
  var token = "".obs;

  Future<void> login(String email, String password) async {
    try {
      const url = "https://demo.alorferi.com/oauth/token";
      var response = await http.post(Uri.parse(url), body: {
        "grant_type": "password",
        "client_id": "2",
        "client_secret": "Cr1S2ba8TocMkgzyzx93X66szW6TAPc1qUCDgcQo",
        "username": email,
        "password": password
      });

      print("This is Statau code of login : ${response.statusCode}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var tokan = data["access_token"];
        print(tokan);
        token.value = data["access_token"];

        await TokenSharePrefences.saveToken(tokan);
        Get.offAll(() => HomePage());
        refresh();
      } else {
        print("Login failed. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error $e");
    }
  }
}
