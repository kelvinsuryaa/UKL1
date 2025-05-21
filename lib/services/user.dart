import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url.dart' as url;
import '../models/response_data_map.dart';

class UserService {
  Future<ResponseDataMap> registerUser(Map<String, dynamic> data) async {
    var uri = Uri.parse("${url.baseUrl}/register_admin");
    var response = await http.post(uri, body: data);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData["status"] == true) {
        return ResponseDataMap(
            status: true, message: "Sukses menambah user", data: responseData);
      } else {
        var message = responseData["message"]
            .entries
            .map((entry) => entry.value[0].toString())
            .join('\n');
        return ResponseDataMap(status: false, message: message);
      }
    } else {
      return ResponseDataMap(
          status: false,
          message:
              "Gagal menambah user dengan kode error ${response.statusCode}");
    }
  }

  Future<ResponseDataMap> loginUser(Map<String, dynamic> data) async {
  var uri = Uri.parse("${url.baseUrl}/login");
  var response = await http.post(uri, body: data);

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    
    if (responseData["status"] == true) {
      return ResponseDataMap(
          status: true, message: "Sukses login user", data: responseData);
    } else {
      return ResponseDataMap(status: false, message: 'Username dan Password Salah');
    }
  } else {
    return ResponseDataMap(
        status: false,
        message: "Gagal login dengan kode error ${response.statusCode}");
  }
}

  Future<ResponseDataMap> getUserProfil() async {
    var uri = Uri.parse("${url.baseUrl}/profil");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      return ResponseDataMap(
          status: true, message: "Profil ditemukan!", data: responseData);
    } else {
      return ResponseDataMap(status: false, message: "Gagal mengambil profil!");
    }
  }

  Future<ResponseDataMap> updateUserProfil(Map<String, dynamic> data) async {
    var uri = Uri.parse("${url.baseUrl}/update_profil");
    var response = await http.post(uri, body: data);

    if (response.statusCode == 200) {
      return ResponseDataMap(
          status: true, message: "Profil berhasil diperbarui!", data: json.decode(response.body));
    } else {
      return ResponseDataMap(status: false, message: "Gagal memperbarui profil!");
    }
  }

   Future<ResponseDataMap> updateUserProfile(
    int id,
    Map<String, dynamic> data,
  ) async {
    var uri = Uri.parse(
      "${url.baseUrl}update/$id",
    ); // Sesuaikan endpoint jika berbeda
    var response = await http.put(
      uri,
      body: data,
    ); // Ganti ke PUT jika API pakai PUT
          print(response.body);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData["status"] == true) {
        return ResponseDataMap(
          status: true,
          message: "Berhasil memperbarui profil",
          data: responseData,
        );
      } else {
        return ResponseDataMap(
          status: false,
          message: responseData["message"] ?? "Gagal memperbarui profil",
        );
      }
    } else {
      return ResponseDataMap(
        status: false,
        message: "Gagal update profil dengan kode error ${response.statusCode}",
      );
    }
  }
}


