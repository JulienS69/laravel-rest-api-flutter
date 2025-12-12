import 'package:laravel_rest_api_flutter/data/core/constants.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_search_body.dart';
import '../../rest_api_repository.dart';

mixin SearchFactory<T> {
  String get baseRoute;
  RestApiClient get httpClient;

  LaravelRestApiSearchBody? get defaultSearchBody => null;

  T fromJson(Map<String, dynamic> json);

  void onCatchError(
    RestApiResponse? response,
    Object exception,
    StackTrace stacktrace,
  );

  Future<RestApiResponse<List<T>>> search({
    TextSearch? text,
    List<Scope>? scopes,
    List<Filter>? filters,
    List<Sort>? sorts,
    List<Select>? selects,
    List<Include>? includes,
    List<Aggregate>? aggregates,
    List<Instruction>? instructions,
    List<String>? gates,
    int? page,
    int? limit,
    Map<String, String>? headers,
  }) async {
    RestApiResponse? response;
    try {
      final mergedSearch = <String, dynamic>{
        ...?defaultSearchBody?.toJson(),
        if (text != null) 'text': text.toJson(),
        if (scopes != null) 'scopes': scopes.map((e) => e.toJson()).toList(),
        if (filters != null) 'filters': filters.map((e) => e.toJson()).toList(),
        if (sorts != null) 'sorts': sorts.map((e) => e.toJson()).toList(),
        if (selects != null) 'selects': selects.map((e) => e.toJson()).toList(),
        if (includes != null)
          'includes': includes.map((e) => e.toJson()).toList(),
        if (aggregates != null)
          'aggregates': aggregates.map((e) => e.toJson()).toList(),
        if (instructions != null)
          'instructions': instructions.map((e) => e.toJson()).toList(),
        if (gates != null) 'gates': gates,
        if (page != null) 'page': page, // FIX
        if (limit != null) 'limit': limit,
      };

      final requestBody = mergedSearch.isEmpty
          ? null
          : <String, dynamic>{'search': mergedSearch};

      response = await handlingResponse(
        '$baseRoute/search',
        headers: headers,
        apiMethod: ApiMethod.post,
        client: httpClient,
        body: requestBody,
      );

      if (!successStatus.contains(response.statusCode)) {
        var message = "Api call return a failed status: ${response.statusCode}";
        if (response.body is Map && response.body.containsKey("message")) {
          message = response.body["message"];
        }
        return RestApiResponse<List<T>>(
          body: response.body,
          message: message,
          statusCode: response.statusCode,
        );
      }
    } catch (exception, stacktrace) {
      onCatchError(response, exception, stacktrace);
      return RestApiResponse<List<T>>(
        body: response?.body,
        message: "Dart exception during api call: $stacktrace",
        statusCode: response?.statusCode,
      );
    }

    try {
      final items = (response.body?['data'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map<T>((item) => fromJson(item))
          .toList();

      return RestApiResponse<List<T>>(
        data: items,
        body: response.body,
        message: response.message,
        statusCode: response.statusCode,
        headers: response.headers,
      );
    } catch (exception, stacktrace) {
      onCatchError(response, exception, stacktrace);
      return RestApiResponse<List<T>>(
        body: response.body,
        message: "Json model deserialize failed: $stacktrace",
        statusCode: response.statusCode,
      );
    }
  }
}
