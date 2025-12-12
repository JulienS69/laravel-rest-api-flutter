// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:laravel_rest_api_flutter/data/core/http_client/rest_api_http_client.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_actions_body.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_mutate_body.dart';
import 'package:laravel_rest_api_flutter/data/core/models/laravel_rest_api/body/laravel_rest_api_search_body.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_actions_factory.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_delete_factory.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_mutate_factory.dart';
import 'package:laravel_rest_api_flutter/data/core/rest_api_factories/laravel_rest_api/laravel_rest_api_search_factory.dart';
import 'package:laravel_rest_api_flutter/data/rest_api_client/api_http_client.dart.dart';

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer YOUR_TOKEN',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  final client = ApiHttpClient(dio: dio);
  final repo = ItemsRepository(client);

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------
  final searchResponse = await repo.search(
    text: TextSearch(value: 'example'),
    page: 1,
    limit: 10,
    sorts: [Sort(field: 'created_at', direction: 'desc')],
  );

  // ---------------------------------------------------------------------------
  // MUTATE (Create)
  // ---------------------------------------------------------------------------
  final mutateResponse = await repo.mutate(
    body: LaravelRestApiMutateBody(
      mutate: [
        Mutation(
          operation: MutationOperation.create,
          attributes: {'name': 'New item', 'status': 'active'},
        ),
      ],
    ),
  );

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------
  final actionsResponse = await repo.actions(
    actionUriKey: 'publish',
    data: LaravelRestApiActionsBody(
      fields: [
        Action(name: 'published_at', value: DateTime.now().toIso8601String()),
      ],
    ),
  );

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------
  final deleteResponse = await repo.delete(resourceIds: [1, 2]);

  // ---------------------------------------------------------------------------
  // RESTORE / FORCE DELETE
  // ---------------------------------------------------------------------------
  // Uncomment only if your SDK exposes these factories with the same "fromJson"
  // signature as Search/Delete.
  //
  // final restoreResponse = await repo.restore(resourceIds: [1, 2]);
  // print('Restore status: ${restoreResponse.statusCode}');
  //
  // final forceDeleteResponse = await repo.forceDelete(resourceIds: [1, 2]);
  // print('Force delete status: ${forceDeleteResponse.statusCode}');
}

/// Example repository
class ItemsRepository
    with
        SearchFactory<Map<String, dynamic>>,
        DeleteFactory<Map<String, dynamic>>,
        MutateFactory,
        ActionsFactory {
  final RestApiClient client;

  ItemsRepository(this.client);

  @override
  String get baseRoute => '/items';

  @override
  RestApiClient get httpClient => client;

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) => json;

  @override
  void onCatchError(
    RestApiResponse? response,
    Object exception,
    StackTrace stacktrace,
  ) {}
}
