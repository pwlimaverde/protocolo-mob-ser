import 'package:dependencies_module/dependencies_module.dart';

class ProcessamentoDadosArquivoHtmlUsecase
    extends UseCaseImplement<Map<String, List<RemessaModel>>> {
  final Datasource<Map<String, List<RemessaModel>>> datasource;

  ProcessamentoDadosArquivoHtmlUsecase({
    required this.datasource,
  });

  @override
  Future<ReturnSuccessOrError<Map<String, List<RemessaModel>>>> call({
    required ParametersReturnResult parameters,
  }) {
    final result = returnUseCase(
      parameters: parameters,
      datasource: datasource,
    );
    return result;
  }
}
