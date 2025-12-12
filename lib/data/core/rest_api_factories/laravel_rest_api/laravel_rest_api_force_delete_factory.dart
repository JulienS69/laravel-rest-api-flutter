import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import '../../rest_api_repository.dart';

mixin ForceDeleteFactory<T> {
  String get baseRoute;
  RestApiClient get httpClient;
  T fromJson(Map<String, dynamic> json);

  Future<RestApiResponse<List<T>>> forceDelete({
    required List<dynamic> resourceIds,
    Map<String, String>? headers,
  }) async {
    final response = await handlingResponse(
      '$baseRoute/force',
      apiMethod: ApiMethod.delete,
      client: httpClient,
      headers: headers,
      body: {"resources": resourceIds},
    );

    final items = (response.body?['data'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map<T>((item) => fromJson(item.cast<String, dynamic>()))
        .toList();

    return RestApiResponse<List<T>>(
      statusCode: response.statusCode,
      headers: response.headers,
      body: response.body,
      data: items,
      message: response.message,
    );
  }
}
