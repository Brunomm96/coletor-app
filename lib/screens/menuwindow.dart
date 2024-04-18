import '../data/menu_app.dart';

import '../models/usuario.dart';
import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuWindow extends StatelessWidget {
  const MenuWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final Usuario usuario =
        ModalRoute.of(context)!.settings.arguments as Usuario;
    return Scaffold(
      backgroundColor: const Color(0xFF414141),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MENU',
        ),
        shadowColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: const Color(0xFFFDB913),
        automaticallyImplyLeading:
            true, //mudar para falte após implementação do app
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color(0xFF414141),
              child: Center(
                child: GridView(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: menu_app.map((cat) {
                    return menuItem(cat);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
