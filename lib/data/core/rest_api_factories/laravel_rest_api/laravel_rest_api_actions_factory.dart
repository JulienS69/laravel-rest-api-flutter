import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_actions_body.dart';
import '../../rest_api_repository.dart';

mixin ActionsFactory {
  String get baseRoute;
  RestApiClient get httpClient;

  Future<RestApiResponse<int>> actions({
    required String actionUriKey,
    required LaravelRestApiActionsBody data,
    Map<String, String>? headers,
  }) async {
    RestApiResponse? response;
    try {
      response = await handlingResponse(
        '$baseRoute/actions/$actionUriKey',
        headers: headers,
        apiMethod: ApiMethod.post,
        client: httpClient,
        body: data.toJson(),
      );
      return RestApiResponse<int>(
        statusCode: response.statusCode,
        body: response.body,
        data: response.body?['data']?['impacted'] ?? 0,
        message: response.message,
        headers: response.headers,
      );
    } catch (exception) {
      return RestApiResponse<int>(
        message: response?.message ?? exception.toString(),
        statusCode: 500,
      );
    }
  }
}
