import 'dart:convert';
import 'package:dependencies_module/dependencies_module.dart';

class RemessaModel {
  final String _id;
  final String nomeArquivo;
  final Timestamp data;
  final Timestamp upload;
  final List<dynamic> idsContrato;
  final int quantidadeProtocolos;
  RemessaModel({
    required this.nomeArquivo,
    required this.data,
    required this.upload,
    required this.idsContrato,
    String? id,
  })  : quantidadeProtocolos = idsContrato.length,
        _id = id ?? const Uuid().v1();

  // ignore: prefer_final_fields
  // id = const Uuid().v1();
  String get id => _id;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'id': id,
      'nomeArquivo': nomeArquivo,
      'data': data,
      'upload': upload,
      'idsContrato': idsContrato,
    };
    return map;
  }

  factory RemessaModel.fromMap(Map<String, dynamic> map) {
    final model = RemessaModel(
      nomeArquivo: map['nomeArquivo'] ?? '',
      data: map['data'],
      upload: map['upload'],
      idsContrato: map['idsContrato'],
      id: map['id'],
    );
    return model;
  }

  String toJson() => json.encode(toMap());

  factory RemessaModel.fromJson(String source) =>
      RemessaModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RemessaModel(Id: $id, Nome do arquivo: $nomeArquivo, Upload: $upload, Data: ${dataFormatoDDMMYYYY.format(data.toDate())}, Ids Contratos: $idsContrato, Quantidade de protocolos: $quantidadeProtocolos)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RemessaModel &&
        other.nomeArquivo == nomeArquivo &&
        other.data == data &&
        listEquals(other.idsContrato, idsContrato);
  }

  @override
  int get hashCode =>
      nomeArquivo.hashCode ^ data.hashCode ^ idsContrato.hashCode;
}
