import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import '../models/menu.dart';

const menu_app = [
  Menu_App(
    id: 'listSep',
    title: 'Listas de Separação',
    color: Colors.amber,
    colorIcon: Colors.black,
    iconForm: Icon(Icons.list),
    route: AppRoutes.listasPage,
  ),
  Menu_App(
    id: 'consultaEndereco',
    title: 'Consulta de Endereço',
    color: Colors.white,
    colorIcon: Colors.black,
    iconForm: Icon(Icons.search_sharp),
    route: AppRoutes.consultaEnder,
  ),
];
