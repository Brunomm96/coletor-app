import 'dart:async';
import 'package:coletor/data/encerrarLista.dart';
import 'package:coletor/models/usuario.dart';
import 'package:coletor/screens/lista_separacao.dart';
import 'package:coletor/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'lista_separacao.dart';

class EncerrarLista extends StatelessWidget {
  const EncerrarLista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ParametersFunction argumentNav =
        ModalRoute.of(context)!.settings.arguments as ParametersFunction;

    return Scaffold(
      appBar: AppBar(
          titleTextStyle: const TextStyle(fontSize: 30),
          titleSpacing: 1,
          backgroundColor: const Color(0xFFFDB913),
          title: Text(
            'Encerrando Lista - ${argumentNav.listas.id}',
          )),
      body: FormularioEncerrar(),
    );
  }
}

class FormularioEncerrar extends StatefulWidget {
  FormularioEncerrar({Key? key}) : super(key: key);

  @override
  State<FormularioEncerrar> createState() => _FormularioEncerrar();
}

class _FormularioEncerrar extends State<FormularioEncerrar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controlQtdVol = TextEditingController();
  final TextEditingController controlEspecie = TextEditingController();
  final TextEditingController controlPesoBruto = TextEditingController();
  final TextEditingController controlPesoLiq = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final MaskTextInputFormatter formatter = new MaskTextInputFormatter(
      mask: '###.###,##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  @override
  Widget build(BuildContext context) {
    ParametersFunction argumentNav =
        ModalRoute.of(context)!.settings.arguments as ParametersFunction;
    final Usuario userData = Usuario();
    userData.re = argumentNav.userRe;

    @override
    void dispose() {
      controlQtdVol.dispose();
      controlEspecie.dispose();
      controlPesoBruto.dispose();
      controlPesoLiq.dispose();
      super.dispose();
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                          ),
                        )
                      ],
                      controller: controlQtdVol,
                      decoration: const InputDecoration(
                        hintText: 'Inclua a Qtde de Volumes',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 3.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '* Campo obrigatório!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controlEspecie,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Espécie',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 3.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '* Campo obrigatório!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controlPesoBruto,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                          ),
                        )
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Inclua Peso Bruto',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 3.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '* Campo obrigatório!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controlPesoLiq,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                          ),
                        )
                      ],
                      //inputFormatters: [formatter],
                      decoration: const InputDecoration(
                        hintText: 'Inclua Líquido',
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 3.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '* Campo obrigatório!';
                        } else if (double.parse(value) < 0) {
                          return '* Campo não pode ser negativo!';
                        }
                        return null;
                      },
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: RoundedLoadingButton(
                          controller: _btnController,
                          color: const Color(0xFFFDB913),
                          child: const Text('Confirmar!',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final String qtdVol = controlQtdVol.text;
                              final String especie = controlEspecie.text;
                              final String pesoBruto = controlPesoBruto.text;
                              final String pesoLiq = controlPesoLiq.text;

                              await fEncerraList(argumentNav.userRe,
                                      argumentNav.listas.id, userData, context)
                                  .timeout(const Duration(seconds: 240));
                            } else {
                              _btnController.reset();
                            }
                          },
                        ),
                      ),
                    ),
                  ])),
              Container()
            ]),
          ),
        ),
      ),
    );
  }

  Future<bool> fEncerraList(
      String re, String numLista, Usuario userData, context) async {
    var retorno = true;
    httpEncerrarList encerrarList = httpEncerrarList(
        re: re,
        numLista: numLista,
        pesoLiq: controlPesoLiq.text,
        especie: controlEspecie.text,
        pesoBruto: controlPesoBruto.text,
        qtdVol: controlQtdVol.text);

    var retFecharList = await encerrarList.apontEncerrarLista();

    var message = showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informativo'),
          content: Text(retFecharList.message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (retFecharList.erro == true) {
                  Navigator.pop(context);
                  _btnController.reset();
                } else {
                  _btnController.success();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.listasPage, ModalRoute.withName(AppRoutes.menu),
                      arguments: userData);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    return retorno;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    String newText = (value / 100).toString();

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
