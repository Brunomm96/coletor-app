import 'package:coletor/screens/consultaEndereco.dart';
import 'package:coletor/screens/encerrarLista.dart';
import 'package:coletor/screens/leitura_de_lista.dart';
import 'package:coletor/screens/lista_separacao.dart';
import 'package:coletor/screens/loginpage.dart';
import 'package:coletor/screens/menuwindow.dart';
import 'package:flutter/material.dart';
import 'utils/app_routes.dart';
import 'screens/loginpage.dart';

void main() => runApp(const COLETOR());

class COLETOR extends StatelessWidget {
  const COLETOR({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coletor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        AppRoutes.home: (ctx) => const LoginPage(),
        AppRoutes.menu: (ctx) => const MenuWindow(),
        AppRoutes.listasPage: (ctx) => ListaSeparacao(),
        AppRoutes.listaRead: (ctx) => LeituraDeLista(),
        AppRoutes.consultaEnder: (ctx) => const ConsultaEndereco(),
        AppRoutes.encerrarList: (ctx) => const EncerrarLista()
      },
    );
  }
}
