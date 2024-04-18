import 'dart:convert';
import 'package:coletor/utils/app_parameters.dart';
import 'package:http/http.dart' as http;
import '../utils/app_routes.dart';
import 'package:coletor/models/padraoRetorno.dart';

// ignore: camel_case_types
class httpEncerrarList {
  final _baseUrl = AppRoutes.urlraizPRD;

  final cEPointValidList = '/rest/api/ws_list_separacao/v1/validlist/';
  final cEPointTrfProds = '/rest/api/ws_list_separacao/v1/trf_prod_list/';
  final cEPointEncerrarList = '/rest/api/ws_list_separacao/v1/fechar_lista/';
  final String re;
  final String numLista;
  final String pesoLiq;
  final String especie;
  final String pesoBruto;
  final String qtdVol;

  Future<PadraoRetorno> apontEncerrarLista() async {
    final queryParameters = {
      'userid': AppParameters.senha,
      're': re,
      'listaid': numLista
    };
    PadraoRetorno retorno = PadraoRetorno(erro: false, message: '');
    // ignore: unused_local_variable
    var cBody = '';
    var uri = Uri.http(_baseUrl, cEPointValidList, queryParameters);

    var response = await http.get(uri).timeout(const Duration(seconds: 240));

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200) {
      uri = Uri.http(_baseUrl, cEPointTrfProds);
      response = await http
          .post(uri,
              body: jsonEncode(<String, String>{
                're': re,
                'listaid': numLista,
                'pesoLiquido': pesoLiq,
                'especie': especie,
                'pesoBruto': pesoBruto,
                'volume': qtdVol
              }))
          .timeout(const Duration(seconds: 240));
      if (response.statusCode > 200 && response.statusCode < 204) {
        uri = Uri.http(_baseUrl, cEPointEncerrarList);
        response = await http
            .post(uri,
                body: jsonEncode(<String, String>{
                  're': re,
                  'listaid': numLista,
                  'pesoLiquido': pesoLiq,
                  'especie': especie,
                  'pesoBruto': pesoBruto,
                  'volume': qtdVol
                }))
            .timeout(const Duration(seconds: 240));
        if (response.statusCode > 200 && response.statusCode < 204) {
          Map<String, dynamic> map = json.decode(response.body);
          retorno = PadraoRetorno(erro: false, message: map["mensagem"]);
        } else {
          Map<String, dynamic> map = json.decode(response.body);
          retorno = PadraoRetorno(erro: true, message: map["message"]);
        }
      } else {
        Map<String, dynamic> map = json.decode(response.body);
        retorno = PadraoRetorno(erro: true, message: map["message"]);
      }
    } else {
      retorno = PadraoRetorno(erro: true, message: map['message']);
    }

    return retorno;
  }

  const httpEncerrarList({
    required this.re,
    required this.numLista,
    required this.pesoLiq,
    required this.especie,
    required this.pesoBruto,
    required this.qtdVol,
  });
}
