import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import '../../models/laravel_rest_api/response/laravel_rest_api_details_response.dart';
import '../../rest_api_repository.dart';

mixin DetailsFactory {
  String get baseRoute;
  RestApiClient get httpClient;

  Future<RestApiResponse<LaravelRestApiDetailsResponse>> details({
    Map<String, String>? headers,
  }) async {
    final response = await handlingResponse(
      baseRoute, // GET api/users
      headers: headers,
      apiMethod: ApiMethod.get,
      client: httpClient,
    );

    if (response.body is Map && response.body['data'] is Map) {
      return RestApiResponse<LaravelRestApiDetailsResponse>(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
        data: LaravelRestApiDetailsResponse.fromJson(
          (response.body['data'] as Map).cast<String, dynamic>(),
        ),
        message: response.message,
      );
    }

    return RestApiResponse<LaravelRestApiDetailsResponse>(
      statusCode: response.statusCode,
      headers: response.headers,
      body: response.body,
      message: response.message,
    );
  }
}
