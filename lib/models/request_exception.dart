import 'package:scrumflow/utils/utils.dart';

class RequestException {
  final int? statusCode;
  final List<String>? errors;

  RequestException({
    this.statusCode,
    this.errors,
  });

  factory RequestException.fromJson(Map<String, dynamic> json) {
    return RequestException(
      statusCode: Helper.keyExists<int>(json, 'status'),
      errors: Helper.keyExists(json, 'errors')?.map<String>((e) => e.toString()).toList() ?? [],
    );
  }
}
