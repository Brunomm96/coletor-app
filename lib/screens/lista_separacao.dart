import 'dart:async';
import 'package:coletor/models/olistaseparacao.dart';
import 'package:coletor/utils/app_routes.dart';
import 'package:flutter/material.dart';
import '../data/table_listas.dart';
import '../models/usuario.dart';

class ListaSeparacao extends StatelessWidget {
  ListaSeparacao({Key? key}) : super(key: key);
  final HttpLists listasReq = HttpLists();

  void showAlert(
      BuildContext context, Text titulo, Text conteudo, Usuario usuario) {
    var snackBar = const SnackBar(
        content: Text("Não existem listas de separação no momento."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final Usuario argumentNav =
        ModalRoute.of(context)!.settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDB913),
        title: const Text('Listas de Separação'),
        shadowColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: listasReq.carregaListas(argumentNav.re),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Listas>> snapshot) {
                if (snapshot.hasData) {
                  List<Listas> listas = snapshot.data as List<Listas>;
                  if (listas.isEmpty) {
                    Future.delayed(
                        Duration.zero,
                        () => showAlert(
                            context,
                            const Text("Listas de Separação"),
                            const Text(
                                "Não existem listas de separação no momento."),
                            argumentNav));
                    Navigator.of(context).pop();
                    return Container();
                  } else {
                    return DataTable(
                      showCheckboxColumn: false,
                      sortAscending: true,
                      sortColumnIndex: 1,
                      columnSpacing: 25,
                      columns: const <DataColumn>[
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Cliente')),
                        DataColumn(label: Text('Dt.Ger')),
                        DataColumn(label: Text('Hr.Ger'))
                      ],
                      rows: List.generate(listas.length, (index) {
                        return DataRow(
                          onSelectChanged: (value) => Navigator.of(context)
                              .pushNamed(AppRoutes.listaRead,
                                  arguments: ParametersFunction(
                                      listas[index], argumentNav.re)),
                          cells: <DataCell>[
                            DataCell(Text(listas[index].id)),
                            DataCell(Text(listas[index].title)),
                            DataCell(Text(listas[index].dataGer)),
                            DataCell(Text(listas[index].horaGer))
                          ],
                        );
                      }),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class ParametersFunction {
  final Listas listas;
  final String userRe;
  ParametersFunction(this.listas, this.userRe);
}
