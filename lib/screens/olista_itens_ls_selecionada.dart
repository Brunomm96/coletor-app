class ItensLista {
  final String cepCliente;
  final double pesoLiquido;
  final double pesoBruto;
  final String estadoCliente;
  final String codigoCliente;
  final String lojaCliente;
  final String nomeCliente;
  final String bairroCliente;
  final String horaSaida;
  final String municipioCliente;
  final String cgcCliente;
  final String enderecoCliente;
  final String dataSaida;
  final String qtdMaior;
  final double separados;
  final double totalPecas;
  final double totalVolumes;
  final List enderecos;

  ItensLista({
    required this.cepCliente,
    required this.pesoLiquido,
    required this.pesoBruto,
    required this.estadoCliente,
    required this.codigoCliente,
    required this.lojaCliente,
    required this.nomeCliente,
    required this.bairroCliente,
    required this.enderecos,
    required this.horaSaida,
    required this.municipioCliente,
    required this.cgcCliente,
    required this.enderecoCliente,
    required this.dataSaida,
    required this.qtdMaior,
    required this.totalPecas,
    required this.separados,
    required this.totalVolumes,
  });
  factory ItensLista.fromJson(Map<String, dynamic> itensJson) {
    return ItensLista(
      cepCliente: itensJson['cepCliente'] as String,
      pesoLiquido: itensJson['pesoLiquido'].toDouble() as double,
      pesoBruto: itensJson['pesoBruto'].toDouble() as double,
      estadoCliente: itensJson['estadoCliente'] as String,
      codigoCliente: itensJson['codigoCliente'] as String,
      lojaCliente: itensJson['lojaCliente'] as String,
      nomeCliente: itensJson['nomeCliente'] as String,
      bairroCliente: itensJson['bairroCliente'] as String,
      enderecos: itensJson['enderecos']
          .map((model) => Enderecos.fromJson(model))
          .toList(),
      horaSaida: itensJson['horaSaida'] as String,
      municipioCliente: itensJson['municipioCliente'] as String,
      cgcCliente: itensJson['cgcCliente'] as String,
      enderecoCliente: itensJson['enderecoCliente'] as String,
      dataSaida: itensJson['dataSaida'] as String,
      qtdMaior: itensJson['qtdMaior'] as String,
      totalPecas: itensJson['totalPecas'].toDouble() as double,
      separados: itensJson['separados'].toDouble() as double,
      totalVolumes: itensJson['totalVolumes'].toDouble() as double,
    );
  }
}

class Enderecos {
  final String endereco;
  final double qtdeEndereco;
  final List produtos;
  Enderecos({
    required this.endereco,
    required this.qtdeEndereco,
    required this.produtos,
  });

  factory Enderecos.fromJson(Map<String, dynamic> itensJson) {
    return Enderecos(
      endereco: itensJson['endereco'] as String,
      qtdeEndereco: itensJson['qtdeEndereco'].toDouble() as double,
      produtos: itensJson['produtos']
          .map((model) => Produtos.fromJson(model))
          .toList(),
    );
  }
}

class Produtos {
  final String codProduto;
  final String etiqueta;
  final double qtdeEtiqueta;
  final String etqtaConfererida;
  final double quantidade;
  final String dtProducao;
  final bool transbordo;
  final bool lida;
  final String semana;
  Produtos(
      {required this.codProduto,
      required this.etiqueta,
      required this.qtdeEtiqueta,
      required this.etqtaConfererida,
      required this.quantidade,
      required this.dtProducao,
      required this.transbordo,
      required this.semana,
      required this.lida});

  factory Produtos.fromJson(Map<String, dynamic> jsonProdutos) {
    return Produtos(
      codProduto: jsonProdutos['codProduto'] as String,
      etiqueta: jsonProdutos['etiqueta'] as String,
      qtdeEtiqueta: jsonProdutos['qtdeEtiqueta'].toDouble() as double,
      quantidade: jsonProdutos['quantidade'].toDouble() as double,
      etqtaConfererida: jsonProdutos['etqtaConfererida'] as String,
      dtProducao: jsonProdutos['dtProducao'] as String,
      transbordo: jsonProdutos['transbordo'] as bool,
      semana: jsonProdutos['semana'],
      lida: jsonProdutos['lida'] as bool,
    );
  }
}
