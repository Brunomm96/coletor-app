import 'dart:convert';
import 'package:coletor/utils/app_parameters.dart';
import 'package:http/http.dart' as http;
import '../utils/app_routes.dart';
import 'package:coletor/models/padraoRetorno.dart';

// ignore: camel_case_types
class httpApontList {
  final _baseUrl = AppRoutes.urlraizPRD;

  final cEPointValidProd = '/rest/api/ws_list_separacao/v1/validprod/';
  final cEPointLerEtiqueta = '/rest/api/ws_list_separacao/v1/ler_etiqueta/';
  final String re;
  final String numLista;
  final String etiqueta;

  Future<PadraoRetorno> apontListSep() async {
    final queryParameters = {
      'userid': AppParameters.senha,
      're': re,
      'prod': etiqueta,
      'listaid': numLista
    };

    // ignore: unused_local_variable
    var cBody = '';
    var uri = Uri.http(_baseUrl, cEPointValidProd, queryParameters);

    var response = await http.get(uri);
    PadraoRetorno retorno = PadraoRetorno(erro: false, message: '');

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200) {
      uri = Uri.http(_baseUrl, cEPointLerEtiqueta);
      response = await http.post(uri,
          body: jsonEncode(<String, String>{
            'etiqueta': etiqueta,
            'listaid': numLista,
            're': re
          }));

      Map<String, dynamic> map = json.decode(response.body);

      if (response.statusCode < 200 || response.statusCode > 204) {
        retorno = PadraoRetorno(erro: true, message: map['message']);
      }
    } else {
      Map<String, dynamic> map = json.decode(response.body);
      if (response.statusCode != 200) {
        retorno = PadraoRetorno(erro: true, message: map['message']);
      }
    }

    return retorno;
  }

  const httpApontList({
    required this.re,
    required this.numLista,
    required this.etiqueta,
  });
}
