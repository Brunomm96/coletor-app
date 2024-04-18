class PadraoRetorno {
  bool erro;
  String message;

  PadraoRetorno({required this.erro, required this.message});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['erro'] = this.erro;
    data['message'] = this.message;
    return data;
  }

  fromJson(Map<String, dynamic> json) {
    erro = json['erro'];
    message = json['message'];
  }
}
