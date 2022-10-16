import 'dart:html';
import 'dart:typed_data';

import 'package:dependencies_module/dependencies_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'mixins/ui/loader/loader_mixin.dart';
import 'mixins/ui/messages/messages_mixin.dart';
import 'widgets/botoes/botao_form/botao_form_widget.dart';
import 'widgets/botoes/botao_limpar/botao_limpar_widget.dart';
import 'widgets/botoes/botao_print/botao_print_widget.dart';
import 'widgets/botoes/botao_search/botao_search_widget.dart';
import 'widgets/botoes/botao_upload/botao_upload_widget.dart';
import 'widgets/forms/form_geral/form_geral_widget.dart';
import 'widgets/header/header_widget.dart';
import 'widgets/menu/menu_widget.dart';
import 'widgets/right/right_widget.dart';

class DesignSystemController extends GetxController
    with LoaderMixin, MessagesMixin {
  @override
  void onInit() {
    super.onInit();
    loaderListener(
      statusLoad: statusLoad,
    );
    messageListener(
      message: message,
    );
    // getModelo();
  }

  //Controller de Loading
  final statusLoad = false.obs;

  //Controller de Messages
  final message = Rxn<MessageModel>();

  //Widgets Pages
  Scaffold scaffold({
    required Widget body,
    required int page,
    required BuildContext context,
  }) {
    coreModuleController.getQuery(context: context);

    return Scaffold(
      drawer: coreModuleController.showMenu
          ? Drawer(
              child: MenuWidget(
                page: page,
              ),
            )
          : null,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(hederHeight),
        child: HeaderWidget(
          titulo: "Sistema Protocolos MOB - SER",
          subtitulo: versaoAtual,
          actions: coreModuleController.pageAtual.value == 2
              ? <Widget>[
                  // _iconButtonSearch(),
                  // _iconButtonPrint(),
                ]
              : coreModuleController.pageAtual.value == 1
                  ? <Widget>[
                      _iconButtonUpload(),
                    ]
                  : [],
        ),
      ),
      backgroundColor: Get.theme.primaryColor,
      body: Column(
        children: <Widget>[
          Obx(() {
            return _body(
              body: body,
              page: page,
            );
          }),
        ],
      ),
    );
  }

  // getModelo() async {
  //   final storage = FirebaseStorage.instance;
  //   final modeloURL =
  //       await storage.ref().child("/modelo/BASE-PROTOCOLO-MOB.jpeg").getData();
  //   print(modeloURL);

  //   final modeloURL2 = await storage
  //       .ref()
  //       .child("/modelo/BASE-PROTOCOLO-MOB.jpeg")
  //       .getData();
  //   print(modeloURL);
  // }

  // Widget _iconButtonSearch() {
  //   return Obx(
  //     () {
  //       return opsController.buscando.value
  //           ? BotaoForm(
  //               form: FormGeral(
  //                 controllerText: opsController.crtlBusca,
  //                 hintText: "Digite a busca",
  //                 labelText: "Busca",
  //                 onChanged: (String value) {
  //                   opsController.busca(value);
  //                 },
  //               ),
  //               button: BotaoLimpar(
  //                 size: 20,
  //                 onPressed: _setLimpar,
  //               ),
  //             )
  //           : BotaoSearch(
  //               size: 20,
  //               onPressed: _setBuscando,
  //             );
  //     },
  //   );
  // }

  Widget iconDownloadXlsx({required RemessaModel filtro}) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      alignment: Alignment.centerLeft,
      icon: const Icon(
        size: 40,
        Icons.download,
        color: Colors.grey,
      ),
      onPressed: (() {
        _downloadXlsx(filtro: filtro);
      }),
    );
  }

  Widget iconButtonPrint({required RemessaModel filtro}) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      alignment: Alignment.centerLeft,
      icon: const Icon(
        size: 40,
        Icons.print,
        color: Colors.grey,
      ),
      onPressed: (() {
        _showPrintDialog(filtro: filtro);
      }),
    );
  }

  Widget _iconButtonUpload() {
    return BotaoUpload(
      size: 20,
      onPressed: _setUpload,
    );
  }

  void _setUpload() {
    uploadRemessaController.setUploadOps();
  }

  // void _setBuscando() {
  //   opsController.buscando(!opsController.buscando.value);
  // }

  // void _setLimpar() {
  //   opsController.crtlBusca.clear();
  //   opsController.busca.value = null;
  //   _setBuscando();
  // }

  Widget _body({
    required Widget body,
    required int page,
  }) {
    return SizedBox(
      width: coreModuleController.size,
      height: coreModuleController.sizeH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          coreModuleController.showMenu
              ? RightWidget(
                  widget: SizedBox(
                    width: coreModuleController.sizeW,
                    height: coreModuleController.sizeH,
                    child: body,
                  ),
                  menuWidth: menuWidth,
                  showMenu: coreModuleController.showMenu,
                  sizeW: coreModuleController.sizeW,
                )
              : Row(
                  children: <Widget>[
                    MenuWidget(
                      page: page,
                    ),
                    RightWidget(
                      widget: SizedBox(
                        width: coreModuleController.sizeW,
                        height: coreModuleController.sizeH,
                        child: body,
                      ),
                      menuWidth: menuWidth,
                      showMenu: coreModuleController.showMenu,
                      sizeW: coreModuleController.sizeW,
                    ),
                  ],
                )
        ],
      ),
    );
  }

  //Widgets OpsList
  // Widget opslistWidget({
  //   required filtro,
  //   required Function(OpsModel) check,
  //   required Function(OpsModel) can,
  //   required Function(OpsModel) prioridade,
  //   required Function(OpsModel) save,
  //   required up,
  // }) {
  //   return OpslistWidget(
  //     up: up,
  //     showMenu: coreModuleController.showMenu,
  //     filtro: filtro,
  //     check: (OpsModel o) {
  //       setOpCheck(o);
  //       check(o);
  //       setOpCheckCan();
  //     },
  //     can: (OpsModel o) {
  //       setOpCan(o);
  //       can(o);
  //       setOpCanCan();
  //     },
  //     save: (OpsModel o) {
  //       save(o);
  //     },
  //     prioridade: (OpsModel o) {
  //       setOpPrioridadeCheck(o);
  //       prioridade(o);
  //       setOpPrioridadeCheckCan();
  //     },
  //   );
  // }

  //Controle OpsList
  DateTime get now => DateTime.now();
  // var formatAno = DateFormat('yyyy');
  final ano = DateFormat('yyyy').format(DateTime.now());
  final f = DateFormat('dd/MM/yy');
  final f2 = DateFormat('dd/MM');
  final fc = DateFormat('dd/MM/yyyy');
  final df = DateFormat('yyyy/MM/dd');
  final numMilhar = NumberFormat(",##0", "pt_BR");

  final colorCrtRyobi = false.obs;

  void setColorCrtRyobi(bool crt) {
    colorCrtRyobi(crt);
  }

  final colorCrtSm2c = false.obs;

  void setColorCrtSm2c(bool crt) {
    colorCrtSm2c(crt);
  }

  final colorCrtryobi750 = false.obs;

  void setColorCrtryobi750(bool crt) {
    colorCrtryobi750(crt);
  }

  final colorCrtFlexo = false.obs;

  void setColorCrtFlexo(bool crt) {
    colorCrtFlexo(crt);
  }

  final colorCrtImp = false.obs;

  void setColorCrtImp(bool crt) {
    colorCrtImp(crt);
  }

  final loadOpCheck = 0.obs;

  // void setOpCheck(OpsModel op) {
  //   loadOpCheck(op.op);
  // }

  void setOpCheckCan() async {
    await 800.milliseconds.delay();
    loadOpCheck(0);
  }

  final loadOpCan = 0.obs;

  // void setOpCan(OpsModel op) {
  //   loadOpCan(op.op);
  // }

  void setOpCanCan() async {
    await 800.milliseconds.delay();
    loadOpCan(0);
  }

  final loadOpPrioridadeCheck = 0.obs;

  // void setOpPrioridadeCheck(OpsModel op) {
  //   loadOpPrioridadeCheck(op.op);
  // }

  // void setOpPrioridadeCheckCan() async {
  //   await 800.milliseconds.delay();
  //   loadOpPrioridadeCheck(0);
  // }

  // String getAtraso(OpsModel model) {
  //   final df = DateFormat('yyyy-MM-dd');
  //   var now = DateTime.parse(df.format(DateTime.now()));
  //   String dayProd;
  //   String dayExped;
  //   String dayEnt;
  //   int dif = int.parse(
  //       now.difference(model.entregaprog ?? model.entrega).inDays.toString());
  //   if (model.cancelada) {
  //     return "";
  //   }
  //   if (model.entregue != null) {
  //     int difEnt = int.parse(now.difference(model.entregue!).inDays.toString());
  //     if (difEnt == 0) {
  //       dayEnt = "- Entregue hoje";
  //     } else if (difEnt > 30) {
  //       dayEnt = "- Entregue";
  //     } else {
  //       dayEnt = "- Entregue a $difEnt dia(s)";
  //     }
  //     return dayEnt;
  //   }
  //   if (model.produzido != null) {
  //     int difExped =
  //         int.parse(now.difference(model.produzido!).inDays.toString());
  //     if (difExped == 0) {
  //       dayExped = "- Entrou hoje em expedição";
  //     } else {
  //       dayExped = "- Entrou em expedição a $difExped dia(s)";
  //     }
  //     return dayExped;
  //   }
  //   if (dif >= 1) {
  //     dayProd = "- Atrasado à ${dif.toString()} dias";
  //   } else if (dif == 0) {
  //     dayProd = "- Entrega hoje";
  //   } else if (-dif == 1) {
  //     dayProd = "- Entrega amanhã";
  //   } else {
  //     dayProd = "- Faltam ${-dif} dia(s) para entrega";
  //   }
  //   return dayProd;
  // }

  // Color? getCorCard(OpsModel model) {
  //   final df = DateFormat('yyyy-MM-dd');
  //   var now = DateTime.parse(df.format(DateTime.now()));
  //   int dif = int.parse(now.difference(model.entrega).inDays.toString());
  //   if (model.cancelada == true) {
  //     return Colors.grey[100];
  //   } else if (model.entregue != null) {
  //     return Colors.grey[100];
  //   } else if (model.produzido != null) {
  //     return Colors.grey[100];
  //   } else if (dif > 0) {
  //     return Colors.redAccent[100];
  //   } else if (dif == 0) {
  //     return Colors.orangeAccent[100];
  //   } else if (dif == -1) {
  //     return Colors.yellowAccent[100];
  //   }
  //   return Colors.grey[100];
  // }

  // PdfColor? getPrintCorCard(OpsModel model) {
  //   final df = DateFormat('yyyy-MM-dd');
  //   var now = DateTime.parse(df.format(DateTime.now()));
  //   int dif = int.parse(now.difference(model.entrega).inDays.toString());
  //   if (model.cancelada == true) {
  //     return PdfColors.grey100;
  //   } else if (model.entregue != null) {
  //     return PdfColors.grey100;
  //   } else if (model.produzido != null) {
  //     return PdfColors.grey100;
  //   } else if (dif > 0) {
  //     return PdfColors.red100;
  //   } else if (dif == 0) {
  //     return PdfColors.orange100;
  //   } else if (dif == -1) {
  //     return PdfColors.yellow100;
  //   }
  //   return PdfColors.grey100;
  // }

  void _downloadXlsx({required RemessaModel filtro}) async {
    final boletos = await remessasController.carregarBoletos(remessa: filtro);
    const camposKeys = <String>[
      "ID Cliente",
      "Cliente",
      "Documento",
      "Email",
      "Telefone Fixo",
      "Telefone Movel",
      "ID Contrato",
      "Data Habilitacao contrato",
      "Número de Boleto",
      "Forma de Cobrança",
      "Data Vencimento Fatura",
      "Valor Fatura",
      "Data Emissao Fatura",
      "Arquivo",
      "Data Impressão Fatura",
      "UF",
      "Cidade",
      "Bairro",
      "Tipo Logradouro",
      "Logradouro",
      "Numero",
      "CEP",
      "Solicitante da Geração",
      "ID Fatura",
      "Referencia",
      "Cód. De Barras",
      "Receb Graf",
      "Imp em massa",
      "Term Imp",
      "Upload",
    ];

    var excel = Excel.createExcel();

    Sheet sheetObject = excel[excel.getDefaultSheet()!];
    CellStyle cellStyleTitulos = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      bold: true,
    );

    sheetObject.merge(
        CellIndex.indexByString("A1"), CellIndex.indexByString("AD1"),
        customValue:
            "SISTEMA DE REGISTRO DE PROTOCOLO - ${filtro.nomeArquivo}");

    var titulo = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    titulo.cellStyle = cellStyleTitulos;

    for (var coluna = 0; coluna < camposKeys.length; coluna++) {
      var cell = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: coluna, rowIndex: 1));
      cell.value = camposKeys[coluna];
      cell.cellStyle = cellStyleTitulos;
    }

    for (BoletoModel boleto in boletos) {
      int indexBoleto = boletos.indexOf(boleto) + 2;
      final listValores = boleto.toListXlsx();
      int indexValor = 0;
      for (dynamic valor in listValores) {
        // print(valor);
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: indexValor, rowIndex: indexBoleto))
            .value = valor;
        indexValor++;
      }
      sheetObject
          .cell(CellIndex.indexByColumnRow(
              columnIndex: indexValor, rowIndex: indexBoleto))
          .value = _gerarCodigoDeBarras(boleto: boleto);
    }

    sheetObject.setColWidth(0, 10);
    sheetObject.setColAutoFit(1);
    sheetObject.setColWidth(2, 0);
    sheetObject.setColWidth(3, 0);
    sheetObject.setColWidth(4, 0);
    sheetObject.setColWidth(5, 0);
    sheetObject.setColAutoFit(6);
    sheetObject.setColWidth(7, 0);
    sheetObject.setColWidth(8, 0);
    sheetObject.setColWidth(9, 0);
    sheetObject.setColAutoFit(10);
    sheetObject.setColWidth(11, 0);
    sheetObject.setColWidth(12, 0);
    sheetObject.setColWidth(13, 0);
    sheetObject.setColWidth(14, 0);
    for (var coluna = 15; coluna < camposKeys.length; coluna++) {
      sheetObject.setColAutoFit(coluna);
    }
    sheetObject.setColWidth(17, 30);
    sheetObject.setColWidth(18, 0);
    sheetObject.setColWidth(22, 0);
    sheetObject.setColWidth(23, 0);
    sheetObject.setColWidth(24, 0);
    sheetObject.setColWidth(25, 25);
    excel.save(fileName: "${filtro.nomeArquivo} - FILTRO.xlsx");
  }

  String _gerarCodigoDeBarras({required BoletoModel boleto}) {
    const sufixo = "ALJ";
    final codBoleto = boleto.numeroDeBoleto;
    String complementoZero = "";
    for (var zero = 0; zero < 14 - (codBoleto!.length); zero++) {
      complementoZero = "${complementoZero}0";
    }
    final tipo = boleto.formaDeCobranca!.contains("CARNE") ? "C" : "B";
    const prefixo = "MB";
    return "$prefixo$tipo$complementoZero$codBoleto$sufixo";
  }

  _showPrintDialog({required RemessaModel filtro}) {
    return Get.dialog(
      AlertDialog(
        title: const Text("Impressão da listagem dos Protoclos"),
        content: SizedBox(
          width: coreModuleController.getSizeProporcao(
            size: coreModuleController.size,
            proporcao: 75,
          ),
          height: coreModuleController.getSizeProporcao(
            size: coreModuleController.sizeH,
            proporcao: 75,
          ),
          child: _pdf2(
            filtro: filtro,
            titulo: "Lista de boletos",
          ),
        ),
      ),
    );
  }

  Future<pw.Widget> _protocolosListPrintWidget({
    required RemessaModel remessa,
    required List<BoletoModel> boletos,
    required dynamic netImage,
  }) async {
    return pw.SizedBox(
      width: coreModuleController.getSizeProporcao(
        size: coreModuleController.size,
        proporcao: 55,
      ),
      child: pw.ListView.builder(
          itemCount: boletos.length,
          itemBuilder: (context, index) {
            final boletoModel = boletos[index];
            return pw.Container(
              // color: PdfColors.amber,
              width: coreModuleController.getSizeProporcao(
                size: coreModuleController.size,
                proporcao: 50,
              ),
              height: 195,
              child: pw.Stack(
                children: [
                  pw.Center(
                    child: pw.Image(netImage),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(0, 0, 3, 8),
                    child: pw.Align(
                      alignment: pw.Alignment.bottomRight,
                      child: pw.Text(
                        remessa.nomeArquivo,
                        style: const pw.TextStyle(fontSize: 5.5),
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(152, 35, 22, 10),
                    child: pw.Container(
                      width: 325,
                      // color: PdfColors.red,
                      child: pw.Text(
                        "${boletoModel.cliente.toString()} - B. ${boletoModel.bairro.toString()} - ${boletoModel.cidade.toString()} / ${boletoModel.uf.toString()} ${boletoModel.tipoLogradouro.toString()} ${boletoModel.logradouro.toString()}, N.:${boletoModel.numero.toString()} - CEP: ${boletoModel.cep.toString()}",
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ),
                  ),
                  _codigoDeBarras(
                    data: _gerarCodigoDeBarras(boleto: boletoModel),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(0, 8, 3, 0),
                    child: pw.Align(
                      alignment: pw.Alignment.topRight,
                      child: pw.Text(
                        "${boletoModel.idContrato.toString()} - ${boletoModel.quantidadeBoletos < 10 ? "0${boletoModel.quantidadeBoletos.toString()}" : boletoModel.quantidadeBoletos.toString()} b",
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(15, 60, 22, 10),
                    child: pw.Align(
                      alignment: pw.Alignment.topRight,
                      child: pw.Text(
                        dataFormatoDDMMYYYY.format(
                          boletoModel.dataVencimentoFatura!.toDate(),
                        ),
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(6, 35, 5, 10),
                    child: pw.Align(
                      alignment: pw.Alignment.bottomLeft,
                      child: pw.Container(
                        width: 127,
                        // color: PdfColors.amber,
                        child: pw.Column(
                          children: [
                            pw.Text(
                              boletoModel.idCliente.toString(),
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                            pw.Text(
                              "${boletoModel.cliente.toString()} - B. ${boletoModel.bairro.toString()} - ${boletoModel.cidade.toString()} / ${boletoModel.uf.toString()} ${boletoModel.tipoLogradouro.toString()} ${boletoModel.logradouro.toString()}, N.:${boletoModel.numero.toString()} - CEP: ${boletoModel.cep.toString()}${boletoModel.referencia.toString() != "null" ? " - REF.:${boletoModel.referencia}" : ""}",
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                            pw.Text(
                              "Remetente:\nMOBTELECOM\nAV. Abolição, 4140 - Mucuripe\nFortaleza - CE\n60165-082",
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                          ],
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  pw.Widget _codigoDeBarras({
    required String data,
  }) {
    final double larguraCodigoDeBarras =
        (data.toString().length * 10.5).toDouble();
    return pw.Padding(
      padding: const pw.EdgeInsets.fromLTRB(10, 10, 10, 83),
      child: pw.Container(
        // color: PdfColors.red100,
        child: pw.Row(
          children: [
            pw.Align(
                alignment: pw.Alignment.bottomLeft,
                child: pw.SizedBox(
                  child: pw.BarcodeWidget(
                    data: data.toString(),
                    width: larguraCodigoDeBarras,
                    height: 45,
                    barcode: pw.Barcode.code128(),
                    drawText: true,
                  ),
                  width: larguraCodigoDeBarras,
                  height: 45,
                )),
            pw.SizedBox(width: 10),
            pw.SizedBox(
              child: pw.BarcodeWidget(
                data: data.toString(),
                width: 45,
                height: 45,
                barcode: pw.Barcode.qrCode(),
                drawText: false,
              ),
              width: 45,
              height: 45,
            ),
            pw.SizedBox(width: 126),
          ],
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          mainAxisAlignment: pw.MainAxisAlignment.end,
        ),
      ),
    );
  }

  Future<pw.Widget> _listaConferenciaPrintWidget({
    required List<BoletoModel> boletos,
  }) async {
    return pw.SizedBox(
      width: coreModuleController.getSizeProporcao(
        size: coreModuleController.size,
        proporcao: 55,
      ),
      child: pw.ListView.builder(
          itemCount: boletos.length,
          itemBuilder: (context, index) {
            final boletoModel = boletos[index];
            return pw.Container(
              decoration: pw.BoxDecoration(
                color: (index % 2) == 0 ? PdfColors.white : PdfColors.grey200,
                border: const pw.Border(
                  top: pw.BorderSide(width: 0.5, color: PdfColors.black),
                  bottom: pw.BorderSide(width: 0.5, color: PdfColors.black),
                ),
              ),
              width: coreModuleController.getSizeProporcao(
                size: coreModuleController.size,
                proporcao: 50,
              ),
              height: 12,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.SizedBox(
                        width: 25,
                        child: pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              "${(index + 1)}",
                              style: const pw.TextStyle(fontSize: 10),
                            )),
                      ),
                      pw.SizedBox(
                        width: 10,
                      ),
                      pw.SizedBox(
                        width: 270,
                        child: pw.Container(
                            child: pw.Text(
                          boletoModel.cliente,
                          style: const pw.TextStyle(fontSize: 10),
                        )),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.SizedBox(
                        width: 100,
                        child: pw.Container(
                            child: pw.Text(
                          "ID Cliente: ${boletoModel.idCliente.toString()}",
                          style: const pw.TextStyle(fontSize: 9),
                        )),
                      ),
                      pw.SizedBox(
                        width: 100,
                        child: pw.Container(
                            child: pw.Text(
                          "ID Contrato: ${boletoModel.idContrato.toString()}",
                          style: const pw.TextStyle(fontSize: 9),
                        )),
                      ),
                      pw.SizedBox(
                        width: 35,
                        child: pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Text(
                              "Boletos: ",
                              style: const pw.TextStyle(fontSize: 9),
                            )),
                      ),
                      pw.SizedBox(
                        width: 15,
                        child: pw.Container(
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              boletoModel.quantidadeBoletos < 10
                                  ? "0${boletoModel.quantidadeBoletos.toString()}"
                                  : boletoModel.quantidadeBoletos.toString(),
                              style: const pw.TextStyle(fontSize: 9),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  _pdf2({
    required RemessaModel filtro,
    required String titulo,
  }) {
    return PdfPreview(
      build: (format) =>
          _generatePdf2(format: format, title: titulo, filtro: filtro),
    );
  }

  // Future<Map<String, dynamic>> _gerarNovoCodigo(BoletoModel model) async {
  //   final codigoDeBarras = await networkImage(
  //       "https://cors-anywhere.herokuapp.com/https://berrywing.com/barcode/Code128.aspx?bc=${model.numeroDeBoleto}");
  //   final Map<String, dynamic> mapCod = {
  //     "boleto": model.numeroDeBoleto,
  //     "codigoDeBarras": codigoDeBarras
  //   };
  //   return mapCod;
  // }

  Future<Uint8List> _generatePdf2({
    required PdfPageFormat format,
    required String title,
    required RemessaModel filtro,
  }) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final netImage = await networkImage(
        "https://firebasestorage.googleapis.com/v0/b/protocolo-mob-ser.appspot.com/o/modelo%2FBASE-PROTOCOLO-MOB.jpeg?alt=media&token=ef0bcb4a-7531-4f7a-8815-63e11eac817e");
    final boletos = await remessasController.carregarBoletos(remessa: filtro);
    // for (BoletoModel boleto in filtro) {
    //   final codigoDeBarras = await networkImage(
    //       "https://cors-anywhere.herokuapp.com/https://berrywing.com/barcode/Code128.aspx?bc=${boleto.numeroDeBoleto}");
    //   final Map<String, dynamic> mapCod = {
    //     "boleto": boleto.numeroDeBoleto,
    //     "codigoDeBarras": codigoDeBarras
    //   };
    //   listCod.add(mapCod);
    // }
    // final Iterable<Future<Map<String, dynamic>>> gerarCodigo =
    //     filtro.map(_gerarNovoCodigo);

    // final Future<Iterable<Map<String, dynamic>>> waited =
    //     Future.wait(gerarCodigo);
    // await waited.then((value) => listCod.addAll(value));
    final protocolos = await _protocolosListPrintWidget(
      remessa: filtro,
      netImage: netImage,
      boletos: boletos,
    );

    final listConferencia =
        await _listaConferenciaPrintWidget(boletos: boletos);

    pdf.addPage(
      pw.MultiPage(
        maxPages: 500,
        pageFormat: format.copyWith(
          marginBottom: 10,
          marginLeft: 20,
          marginRight: 20,
          marginTop: 20,
        ),
        build: (context) => [
          pw.SizedBox(height: 10),
          protocolos,
          pw.SizedBox(height: 10),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        maxPages: 500,
        pageFormat: format.copyWith(
          marginBottom: 10,
          marginLeft: 20,
          marginRight: 20,
          marginTop: 20,
        ),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "Lista para conferencia - ${filtro.nomeArquivo}",
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 10),
          listConferencia
        ],
      ),
    );

    return pdf.save();
  }
}
