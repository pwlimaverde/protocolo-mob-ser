import 'dart:convert';
import 'package:dependencies_module/dependencies_module.dart';

class RemessaModel {
  final String nomeArquivo;
  final Timestamp data;
  final Timestamp upload;
  final List<BoletoModel> remessa;
  final int quantidadeProtocolos;
  RemessaModel({
    required this.nomeArquivo,
    required this.data,
    required this.upload,
    required this.remessa,
  }) : quantidadeProtocolos = remessa.length;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'nomeArquivo': nomeArquivo,
      'data': data,
      'upload': upload,
      'remessa': remessa.map((x) => x.toMap()).toList(),
    };
    return map;
  }

  factory RemessaModel.fromMap(Map<String, dynamic> map) {
    // print("#####");
    // print(map['data']);
    // print("#####");
    // print("#####");
    // print(DateTime.fromMillisecondsSinceEpoch(map['data']));
    // print("#####");
    return RemessaModel(
      nomeArquivo: map['nomeArquivo'] ?? '',
      data: map['data'],
      upload: map['upload'],
      remessa: List<BoletoModel>.from(
          map['remessa']?.map((x) => BoletoModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory RemessaModel.fromJson(String source) =>
      RemessaModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RemessaModel(nome do arquivo: $nomeArquivo, upload: $upload, data: ${dataFormatoDDMMYYYY.format(data.toDate())}, remessa: $remessa, quantidade de protocolos: $quantidadeProtocolos)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RemessaModel &&
        other.nomeArquivo == nomeArquivo &&
        other.data == data &&
        listEquals(other.remessa, remessa);
  }

  @override
  int get hashCode => nomeArquivo.hashCode ^ data.hashCode ^ remessa.hashCode;
}
