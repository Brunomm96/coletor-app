import 'package:coletor/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class ConsultaEndereco extends StatelessWidget {
  const ConsultaEndereco({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Usuario argumentNav =
        ModalRoute.of(context)!.settings.arguments as Usuario;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDB913),
          title: const Text('Consulta de Endereço'),
          shadowColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        // ignore: avoid_unnecessary_containers
        body: const Center(child: Text("Rotina em desenvolvimento.")));
  }
}
