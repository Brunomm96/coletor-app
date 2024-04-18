// ignore_for_file: prefer_const_constructors_in_immutables, deprecated_member_use
//import 'package:accordion/controllers.dart';
import 'package:coletor/data/encerrarLista.dart';
import 'package:coletor/models/padraoRetorno.dart';
import 'package:coletor/models/usuario.dart';
import 'package:coletor/utils/app_routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:accordion/accordion.dart';
import 'package:coletor/data/table_itens_lista.dart';
import 'package:coletor/screens/olista_itens_ls_selecionada.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:pie_chart/pie_chart.dart'
//  show ChartType, ChartValuesOptions, LegendOptions, LegendPosition, PieChart;
import 'package:coletor/data/apontListSep.dart';
import '../models/olistaseparacao.dart';
import 'lista_separacao.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(LeituraDeLista());
}

class LeituraDeLista extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LeituraDeLista> {
  String codigoBarras = '';
  final TextEditingController _codebarControl = TextEditingController();
  final FocusNode _textNode = FocusNode();

  final HttpListItens listasItens = HttpListItens();
  List<ItensLista> itensLista = [];

  @override
  void initState() {
    _textNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _codebarControl.dispose();
    super.dispose();
  }

  Future startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        // ignore: avoid_print
        .listen((barcode) => print(barcode));
  }

  Future<bool> fReqApi(
      String cpoValue, String re, String numLista, Listas lista) async {
    var retorno = true;
    PadraoRetorno retApontamento;
    if (cpoValue.isNotEmpty) {
      httpApontList apontamento =
          httpApontList(re: re, numLista: numLista, etiqueta: cpoValue);
      retApontamento = await apontamento
          .apontListSep()
          .timeout(const Duration(seconds: 240));
      if (retApontamento.erro == true) {
        var message = showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Informativo'),
              content: Text(retApontamento.message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, AppRoutes.listaRead,
                        arguments: ParametersFunction(lista, re));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          Navigator.popAndPushNamed(context, AppRoutes.listaRead,
              arguments: ParametersFunction(lista, re));
        });
      }
    }
    return retorno;
  }

  Future scanQR(re, numLista, lista) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      codigoBarras = barcodeScanRes;
      _codebarControl.text = codigoBarras;
      fReqApi(codigoBarras, re, numLista, lista);
    });
  }

  Future scanBarcodeNormal(re, numLista, lista) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (barcodeScanRes == '-1') barcodeScanRes = '';
    if (!mounted) return;
    setState(() {
      codigoBarras = barcodeScanRes;
      _codebarControl.text = codigoBarras;
      fReqApi(codigoBarras, re, numLista, lista);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ParametersFunction argumentNav =
        ModalRoute.of(context)!.settings.arguments as ParametersFunction;
    final Usuario userData = Usuario();
    userData.re = argumentNav.userRe;
    return WillPopScope(
      onWillPop: () async => onBackPressed(context, userData),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleTextStyle: const TextStyle(fontSize: 12),
            titleSpacing: 1,
            backgroundColor: const Color(0xFFFDB913),
            title: Text(
              'Separação - ${argumentNav.listas.id + ' - ' + argumentNav.listas.title}',
            ),
            shadowColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                    future: listasItens.carregaItens(
                        argumentNav.userRe, argumentNav.listas.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ItensLista>> snapshot) {
                      if (snapshot.hasData) {
                        itensLista = snapshot.data as List<ItensLista>;

                        return Column(children: <Widget>[
                          Flexible(
                            flex: 0,
                            fit: FlexFit.loose,
                            child: Row(
                              children: <Widget>[
                                Column(children: <Widget>[
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          const Icon(
                                            MdiIcons.packageVariant,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    'Etqtas Lidas: ${itensLista[0].separados.toStringAsFixed(2)}'),
                                                Text(
                                                    'Etqtas Pendentes: ${(itensLista[0].totalPecas - itensLista[0].separados).toStringAsFixed(2)}')
                                              ])
                                        ])
                                      ],
                                    ),
                                  ),
                                ]),
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.9,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      color: Colors.white,
                                      child: SizedBox(
                                        child: Stack(
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      const Text(
                                                        "TOTAL PEÇAS:",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(itensLista[0]
                                                          .totalPecas
                                                          .toString())
                                                    ],
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              /*width: MediaQuery.of(context).size.width,
                              height: (MediaQuery.of(context).size.height / 6.5) *
                                  3.8,*/
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Accordion(
                                  headerBorderRadius: 0,
                                  headerBackgroundColor:
                                      const Color(0xFFFDB913),
                                  paddingListTop: 0,
                                  paddingListBottom: 0,
                                  paddingListHorizontal: 2,
                                  paddingBetweenClosedSections: 0,
                                  contentVerticalPadding: 0,
                                  children: listAccordionSections(
                                      itensLista[0].enderecos,
                                      MediaQuery.of(context).size.width)),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              color: Colors.white,
                              /*width: MediaQuery.of(context).size.width,
                              height: (MediaQuery.of(context).size.height / 9),*/
                              child: TextField(
                                controller: _codebarControl,
                                focusNode: _textNode,
                                autofocus: true,
                                textAlign: TextAlign.center,
                                cursorColor: const Color(0xFF414141),
                                onSubmitted: (String value) async {
                                  await fReqApi(
                                      value,
                                      argumentNav.userRe,
                                      argumentNav.listas.id,
                                      argumentNav.listas);
                                },
                                decoration: const InputDecoration(
                                    hoverColor: Color(0xFF414141),
                                    focusColor: Color(0xFF414141),
                                    fillColor: Colors.white,
                                    labelText: 'Código de Etiqueta',
                                    labelStyle:
                                        TextStyle(color: Color(0xFF414141)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF414141)))),
                              ),
                            ),
                          )
                        ]);
                      } else {
                        return Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Center(
                              heightFactor:
                                  MediaQuery.of(context).size.height / 2,
                              widthFactor:
                                  MediaQuery.of(context).size.width / 2,
                              child: const RefreshProgressIndicator(),
                            ));
                      }
                    }),
              ),
            ],
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            icon: Icons.inventory_2,
            backgroundColor: const Color(0xFF414141),
            overlayColor: Colors.black,
            overlayOpacity: 0.4,
            label: const Text('Ações'),
            children: [
              SpeedDialChild(
                  child: const Icon(MdiIcons.barcodeOff),
                  backgroundColor: Colors.amber.shade500,
                  label: 'Cód. Barras em Lote',
                  onTap: () => showToast("Funcionalidade em desenvolvimento.")),
              SpeedDialChild(
                  child: const Icon(MdiIcons.barcode),
                  backgroundColor: Colors.amber.shade500,
                  label: 'Cód. Barras',
                  onTap: () => scanBarcodeNormal(argumentNav.userRe,
                      argumentNav.listas.id, argumentNav.listas)),
              SpeedDialChild(
                  backgroundColor: Colors.amber.shade300,
                  child: const Icon(MdiIcons.qrcode),
                  label: 'QRCode',
                  onTap: () => scanQR(argumentNav.userRe, argumentNav.listas.id,
                      argumentNav.listas)),
              SpeedDialChild(
                  backgroundColor: Colors.green.shade700,
                  child: const Icon(MdiIcons.doorOpen),
                  label: 'Encerrar Lista',
                  onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Alerta"),
                            content: Text("Deseja encerrar a lista " +
                                argumentNav.listas.id +
                                "? ."),
                            actions: [
                              TextButton(
                                child: const Text("Não"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: const Text("Sim"),
                                onPressed: () async {
                                  if (itensLista[0].estadoCliente != "EX") {
                                    Navigator.pushNamed(
                                        context, AppRoutes.encerrarList,
                                        arguments: ParametersFunction(
                                            argumentNav.listas,
                                            argumentNav.userRe));
                                  } else {
                                    await fEncerraList(
                                            argumentNav.userRe,
                                            argumentNav.listas.id,
                                            userData,
                                            context)
                                        .timeout(const Duration(seconds: 240));
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      )),
              SpeedDialChild(
                  backgroundColor: Colors.amber.shade900,
                  child: const Icon(MdiIcons.doorOpen),
                  label: 'Sair',
                  onTap: () => (showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Alerta"),
                            content: const Text("Deseja sair desta lista?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancelar"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text("Confirmar"),
                                onPressed: () {
                                  setState(() => Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          AppRoutes.listasPage,
                                          ModalRoute.withName(AppRoutes.menu),
                                          arguments: userData));
                                },
                              ),
                            ],
                          );
                        },
                      ))),
            ],
          )),
    );
  }

  List<AccordionSection> listAccordionSections(List items, double nWidth) {
    TextStyle _headerStyle = const TextStyle(
        color: Color(0xFF414141), fontSize: 12, fontWeight: FontWeight.bold);
    // TextStyle: unused_field
    TextStyle _contentStyleHeader = const TextStyle(
      color: Color(0xff999999),
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    List<AccordionSection> result = [];

    for (var s in items) {
      result.add(AccordionSection(
          isOpen: true,
          leftIcon: const Icon(MdiIcons.packageDown, color: Color(0xFF414141)),
          header: Text(s.endereco, style: _headerStyle),
          contentBorderColor: Colors.amberAccent.shade700,
          content: DataTable(
            sortAscending: true,
            sortColumnIndex: 1,
            dataRowHeight: 30,
            headingRowHeight: 20,
            columnSpacing: 10,
            columns: [
              DataColumn(
                label: Container(
                    width: nWidth * 0.10,
                    alignment: Alignment.center,
                    child: Text('Cód.Prod', style: _contentStyleHeader)),
              ),
              DataColumn(
                label: Container(
                    width: nWidth * 0.13,
                    alignment: Alignment.center,
                    child: Text('Etiqueta', style: _contentStyleHeader)),
              ),
              DataColumn(
                  label: Container(
                      alignment: Alignment.center,
                      width: nWidth * .08,
                      child: Text('Dt.Prod', style: _contentStyleHeader))),
              DataColumn(
                  label: Container(
                      alignment: Alignment.center,
                      width: nWidth * .05,
                      child: Text('Sem', style: _contentStyleHeader))),
              DataColumn(
                  label: Container(
                      alignment: Alignment.center,
                      width: nWidth * .10,
                      child: Text('Qtd Etiq.', style: _contentStyleHeader)))
            ],
            rows: listDataRow(s.produtos, nWidth),
          )));
    }
    return result;
  }
}

List<DataRow> listDataRow(List items, nWidth) {
  TextStyle _contentStyle = const TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 12,
      fontWeight: FontWeight.normal);
  List<DataRow> result = [];

  for (var s in items) {
    result.add(DataRow(color: getBackgroundColor(s), cells: [
      DataCell(Center(
        child: Text(s.codProduto.toString().trim(),
            style: _contentStyle, textAlign: TextAlign.center),
      )),
      DataCell(
          Text(s.etiqueta, style: _contentStyle, textAlign: TextAlign.center)),
      DataCell(Center(
        child: Text(s.dtProducao,
            style: _contentStyle, textAlign: TextAlign.center),
      )),
      DataCell(Center(
        child: Text(s.semana.toString(),
            style: _contentStyle, textAlign: TextAlign.center),
      )),
      DataCell(Center(
        child: Text(s.qtdeEtiqueta.toString(),
            style: _contentStyle, textAlign: TextAlign.center),
      )),
    ]));
  }
  return result;
}

getBackgroundColor(s) {
  final MaterialStateProperty<Color> dataRowColor;
  if (s.lida) {
    return MaterialStateColor.resolveWith(
        (states) => Colors.orangeAccent.shade100);
  } else {
    return MaterialStateColor.resolveWith((states) => Colors.white);
  }
}

Future showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      fontSize: 18,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.amber.shade500,
      textColor: Colors.black);
}

Future<bool> fEncerraList(
    String re, String numLista, Usuario userData, context) async {
  var retorno = true;
  httpEncerrarList encerrarList = httpEncerrarList(
      re: re,
      numLista: numLista,
      pesoLiq: '0',
      especie: '0',
      pesoBruto: '0',
      qtdVol: '0');

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
              } else {
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

Future<bool> onBackPressed(context, userData) async {
  bool ret = false;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Você tem certeza?'),
      content: const Text('Você irá voltar para a tela de listagem de Ops'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () {
            ret = true;
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.listasPage, ModalRoute.withName(AppRoutes.menu),
                arguments: userData);
            ;
          },
          child: const Text('Sim'),
        ),
      ],
    ),
  );

  return ret;
}
