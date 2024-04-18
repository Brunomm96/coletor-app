import 'dart:convert';
import 'package:coletor/screens/olista_itens_ls_selecionada.dart';
import 'package:coletor/utils/app_parameters.dart';
import 'package:http/http.dart' as http;
import '../utils/app_routes.dart';

class HttpListItens {
  final _baseUrl = AppRoutes.urlraizPRD;

  final cEPoint = '/rest/api/ws_list_separacao/v1/consulta/';

  Future<List<ItensLista>> carregaItens(String re, String numLista) async {
    final queryParameters = {
      'userid': AppParameters.senha,
      're': re,
    };

    // ignore: unused_local_variable
    var cBody = '';
    final uri = Uri.http(_baseUrl, cEPoint + numLista, queryParameters);

    final response = await http.get(uri);

    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["itens"];

    List<ItensLista> itens =
        List<ItensLista>.from(data.map((model) => ItensLista.fromJson(model)));

    return itens;
  }
}
