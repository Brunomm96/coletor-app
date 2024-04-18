import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/app_routes.dart';

class Usuario {
  String _re = '';
  String _nome = '';
  String _message = '';

  set re(novoRe) {
    _re = novoRe;
  }

  String get re {
    return _re;
  }

  set nome(novoNome) {
    _nome = novoNome;
  }

  String get nome {
    return _nome;
  }

  set message(novaMess) {
    _message = novaMess;
  }

  String get message {
    return _message;
  }
}

Future<Usuario> autentica(String reForm, BuildContext context) async {
  var _baseUrl = AppRoutes.urlraizPRD;
  var cEPoint = '/rest/WS_ROMANEIO_DIGITAL/loginporre';
  var userLog = Usuario();
  var oJsResponse;
  // ignore: unused_local_variable
  var cBody = '';
  var uri = Uri.http(_baseUrl, cEPoint);
  var snackBar = const SnackBar(content: Text("informação"));
  var response = await http.post(
    uri,
    body: cBody = jsonEncode({"RE": reForm}),
  );
  oJsResponse = jsonDecode(response.body);
  try {
    if (response.statusCode >= 200 &&
        response.statusCode <= 299 &&
        oJsResponse['status'] == null &&
        oJsResponse['NOME'] != '') {
      // ignore: avoid_print
      print(oJsResponse['NOME']);
      userLog.nome = oJsResponse['NOME'];
      userLog.re = oJsResponse['RE'];
    } else {
      // ignore: avoid_print
      snackBar = SnackBar(content: Text(jsonDecode(response.body)['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return userLog;
  } catch (exc) {
    return userLog;
  }
}
