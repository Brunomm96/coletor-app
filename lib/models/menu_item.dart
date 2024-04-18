import 'package:flutter/material.dart';

import 'menu.dart';

class menuItem extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final Menu_App menu_App;

  // ignore: use_key_in_widget_constructors
  const menuItem(this.menu_App);

  void _selectMenu(BuildContext context, rota, argumentos) {
    Navigator.of(context).pushNamed(rota, arguments: argumentos);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectMenu(
          context, menu_App.route, ModalRoute.of(context)!.settings.arguments),
      splashColor: Theme.of(context).secondaryHeaderColor,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            IconButton(
                icon: menu_App.iconForm,
                color: menu_App.colorIcon,
                iconSize: 50,
                tooltip: menu_App.title,
                onPressed: () {
                  _selectMenu(context, menu_App.route,
                      ModalRoute.of(context)!.settings.arguments);
                }),
            Text(
              menu_App.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            )
          ]),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              menu_App.color.withOpacity(0.5),
              menu_App.color,
            ],
          ),
        ),
      ),
    );
  }
}
