// ignore: camel_case_types
class Listas {
  final String id;
  final String title;
  final String dataGer;
  final String horaGer;

  Listas({
    required this.id,
    required this.title,
    this.dataGer = '22/02/2020',
    this.horaGer = '11:88',
  });
  factory Listas.fromJson(Map<String, dynamic> json) {
    return Listas(
      id: json['lista'] as String,
      title: json['nome'] as String,
      dataGer: json['data'] as String,
      horaGer: json['hora'] as String,
    );
  }
}
