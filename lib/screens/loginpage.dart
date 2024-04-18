import 'package:coletor/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/usuario.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: prefer_const_constructors
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const Loginapp());
}

var _re = TextEditingController();
var serverEndPoint = TextEditingController();

class Loginapp extends StatelessWidget {
  const Loginapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Coletor',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final String logo = 'assets/images/datawake.png';
  final _formKey = GlobalKey<FormState>();

  @override
  // ignore: must_call_super
  void initState() {
    final prefs = SharedPreferences.getInstance();
    String endPoint = "endPoint";

    super.initState();
    serverEndPoint.text = prefs.getString(endPoint);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: const Color(0xFF414141),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.1,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                  color: Color(0xFFf2f3f4),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(120))),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/images/datawake.png',
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.8,
              padding: const EdgeInsets.only(top: 100),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: Color(0xFF414141),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFDB913),
                              blurRadius: 15,
                            )
                          ]),
                      child: TextFormField(
                        controller: _re,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, preencha o número do RE';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Insira seu RE',
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.person,
                              color: Color(0xFFFDB913),
                            )),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Divider(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 100,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusScopeNode currentfocus =
                                FocusScope.of(context);
                            Usuario usuario = Usuario();
                            Usuario argumentsNav = Usuario();
                            if (_formKey.currentState!.validate()) {
                              usuario = await autentica(_re.text, context);

                              LoadingFlipping.circle(
                                borderColor: Colors.cyan,
                                borderSize: 3.0,
                                size: 30.0,
                                backgroundColor: Colors.cyanAccent,
                                duration: const Duration(milliseconds: 500),
                              );
                              argumentsNav = usuario;
                              if (!currentfocus.hasPrimaryFocus) {
                                currentfocus.unfocus();
                              }
                              var cmsg = '';
                              if (usuario.nome.isNotEmpty) {
                                cmsg = "Boas Vindas " + usuario.nome;
                              } else {
                                cmsg = "Falha:" + usuario.message;
                              }
                              var snackBar = SnackBar(content: Text(cmsg));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            if (usuario.message.isEmpty &&
                                usuario.nome.isNotEmpty) {
                              Navigator.of(context).pushNamed(AppRoutes.menu,
                                  arguments: argumentsNav);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: const Color(0xFFFDB913),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              side: const BorderSide(
                                  color: Colors.black, width: 2),
                              textStyle: const TextStyle(fontSize: 40)),
                          child: const Text("Login"),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 6.2,
                      child: ElevatedButton(
                          onPressed: () => _asyncInputDialog(context),
                          child: Icon(Icons.settings)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

Future _asyncInputDialog(BuildContext context) async {
// Obtain shared preferences.
  final prefs = await SharedPreferences.getInstance();

  return showDialog(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Informe o Endpoint do servidor de serviços!'),
        content: Row(
          children: [
            Expanded(
                child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'EndPoint:', hintText: '192.168.0.31:8092'),
              controller: serverEndPoint,
            ))
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              prefs.setString('endpoint', serverEndPoint.text);
            },
          ),
        ],
      );
    },
  );
}
