import 'package:dependencies_module/dependencies_module.dart';
import 'package:flutter_excel/excel.dart' as flutterexcel;
import 'dart:convert' as convert;

import '../../../utils/parametros/parametros_upload_remessa_module.dart';

class MapeamentoDadosArquivoHtmlDatasource
    implements Datasource<List<Map<String, Map<String, dynamic>>>> {
  @override
  Future<List<Map<String, Map<String, dynamic>>>> call(
      {required ParametersReturnResult parameters}) async {
    if (parameters is ParametrosMapeamentoArquivoHtml) {
      List<Map<String, Uint8List>> mapBytes = parameters.listaMapBytes;

      if (mapBytes.isNotEmpty) {
        List<Map<String, Map<String, dynamic>>> listaArquivos = [];
        for (Map<String, Uint8List> map in mapBytes) {
          final Map<String, Map<String, dynamic>> mapArquivo = {
            "arquivo": _listaProcessada(map: map),
          };
          listaArquivos.add(mapArquivo);
        }
        return listaArquivos;
      } else {
        throw Exception(
            "Erro ao mapear as informaões do arquivo - ${parameters.error}");
      }
    } else {
      throw Exception(
          "Erro ao mapear as informaões do arquivo - - ${parameters.error}");
    }
  }

  Map<String, dynamic> _listaProcessada({
    required Map<String, Uint8List> map,
  }) {
    if (map.keys.first.contains(".csv")) {
      return _processamentoCsv(
        map: map,
      );
    } else if (map.keys.first.contains(".xlsx")) {
      return _processamentoXlsx(
        map: map,
      );
    } else {
      throw Exception("Arquivo carregado precisa ter extenção xlsx ou csv");
    }
  }

  Map<String, dynamic> _processamentoXlsx({
    required Map<String, Uint8List> map,
  }) {
    try {
      var excel = flutterexcel.Excel.decodeBytes(map.values.first);
      flutterexcel.Sheet sheetObject = excel[excel.getDefaultSheet()!];
      // List<List<dynamic>> listXlsx = [];
      Map<String, dynamic> mapXlsx = {};
      // List<List<dynamic>> listaDados = [];
      List<Map<String, String>> mapDados = [];

      // listXlsx.addAll(decoder.tables[decoder.tables.keys.first]!.rows);
      // print(listXlsx);

      mapXlsx.addAll({"nome do arquivo": map.keys.first.split(".")[0]});
      final dataProcessada = DateTime.parse(sheetObject.rows[0][24]?.value);
      mapXlsx.addAll({"data da remessa": dataProcessada});

      mapXlsx.addAll({"tipo do arquivo": "xlsx"});

      // listaDados.addAll(listXlsx);
      // listaDados.removeRange(0, 2);

      if (sheetObject.rows.isNotEmpty) {
        final cabecario = sheetObject.rows[1];
        sheetObject.removeRow(0);
        sheetObject.removeRow(0);

        for (List<flutterexcel.Data?> row in sheetObject.rows) {
          Map<String, String> modelJason = {};
          for (flutterexcel.Data? celula in row) {
            int indexL = row.indexOf(celula);
            modelJason.addAll(
                {"${cabecario[indexL]?.value}": "${celula?.value ?? "."}"});
          }
          final key1 = modelJason.keys.first;
          final value1 = int.tryParse(modelJason['ID Cliente'].toString());
          if (key1 == 'ID Cliente' && value1 != null && value1 > 0) {
            mapDados.add(modelJason);
          }
        }
      }
      mapXlsx.addAll({"remessa": mapDados});
      return mapXlsx;
    } catch (e) {
      Map<String, dynamic> mapCatch = {
        "nome do arquivo": map.keys.first.split(".")[0],
        "data da remessa": DateTime.now(),
        "remessa": <Map<String, String>>[],
      };
      return mapCatch;
    }
  }

  Map<String, dynamic> _processamentoCsv({
    required Map<String, Uint8List> map,
  }) {
    try {
      final decoderByte = convert.latin1.decode(map.values.first);
      List<List<dynamic>> listCsv = [];
      List<List<dynamic>> listaDados = [];
      Map<String, dynamic> mapCsv = {};
      List<Map<String, String>> mapDados = [];

      listCsv.addAll(
          const CsvToListConverter(fieldDelimiter: ";").convert(decoderByte));

      mapCsv.addAll({"nome do arquivo": map.keys.first.split(".")[0]});
      final DateTime dataProcessada = DateTime.parse(
        "${listCsv[0].last.substring(6, 10)}-${listCsv[0].last.substring(3, 5)}-${listCsv[0].last.substring(0, 2)}",
      );
      mapCsv.addAll({"data da remessa": dataProcessada});
      mapCsv.addAll({"tipo do arquivo": "csv"});

      listaDados.addAll(listCsv);
      listaDados.removeRange(0, 2);
      if (listaDados.isNotEmpty) {
        List<dynamic> cabecario = listCsv[1];
        for (List<dynamic> lista in listaDados) {
          Map<String, String> modelJason = {};
          int index = 0;
          for (dynamic item in lista) {
            modelJason
                .addAll({"${cabecario[index]}": item != "" ? "$item" : "."});
            index++;
          }
          final key1 = modelJason.keys.first;
          final value1 = int.tryParse(modelJason['ID Cliente'].toString());
          if (key1 == 'ID Cliente' && value1 != null && value1 > 0) {
            mapDados.add(modelJason);
          }
        }
      }
      mapCsv.addAll({"remessa": mapDados});
      return mapCsv;
    } catch (e) {
      Map<String, dynamic> mapCatch = {
        "nome do arquivo": map.keys.first.split(".")[0],
        "data da remessa": DateTime.now(),
        "remessa": <Map<String, String>>[],
      };
      return mapCatch;
    }
  }
}
