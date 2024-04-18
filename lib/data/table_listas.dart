import 'dart:convert';
import 'package:coletor/utils/app_parameters.dart';
import 'package:http/http.dart' as http;
import '../utils/app_routes.dart';
import '../models/olistaseparacao.dart';

class HttpLists {
  final _baseUrl = AppRoutes.urlraizPRD;
  final cEPoint = '/rest/api/ws_list_separacao/v1/consulta/';

  Future<List<Listas>> carregaListas(String re) async {
    final queryParameters = {
      'userid': AppParameters.senha,
      're': re,
    };

    final uri = Uri.http(_baseUrl, cEPoint, queryParameters);

    final response = await http.get(uri);
    List<Listas> listas = List<Listas>.empty();
    List<dynamic> data = [];

    Map<String, dynamic> map = json.decode(response.body);
    if (map["listas"] != null) {
      data = map["listas"];
      listas = List<Listas>.from(data.map((model) => Listas.fromJson(model)));
    }
    return listas;
  }
}
