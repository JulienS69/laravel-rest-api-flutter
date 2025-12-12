class LaravelRestApiDetailsResponse {
  final List<RestAction> actions;
  final List<RestInstruction> instructions;
  final List<String> fields;
  final List<int> limits;
  final List<String> scopes;

  final Map<String, dynamic> extra;

  const LaravelRestApiDetailsResponse({
    required this.actions,
    required this.instructions,
    required this.fields,
    required this.limits,
    required this.scopes,
    this.extra = const {},
  });

  factory LaravelRestApiDetailsResponse.fromJson(Map<String, dynamic> json) {
    final known = <String>{
      'actions',
      'instructions',
      'fields',
      'limits',
      'scopes',
    };
    final extra = <String, dynamic>{};
    for (final e in json.entries) {
      if (!known.contains(e.key)) extra[e.key] = e.value;
    }

    return LaravelRestApiDetailsResponse(
      actions: (json['actions'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => RestAction.fromJson(e.cast<String, dynamic>()))
          .toList(),
      instructions: (json['instructions'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => RestInstruction.fromJson(e.cast<String, dynamic>()))
          .toList(),
      fields: (json['fields'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      limits: (json['limits'] as List<dynamic>? ?? const [])
          .map((e) => (e as num).toInt())
          .toList(),
      scopes: (json['scopes'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      extra: extra,
    );
  }
}

class RestAction {
  final String name;
  final String uriKey;
  final Map<String, List<String>> fields;
  final Map<String, dynamic>? meta;
  final bool isStandalone;

  const RestAction({
    required this.name,
    required this.uriKey,
    required this.fields,
    this.meta,
    required this.isStandalone,
  });

  factory RestAction.fromJson(Map<String, dynamic> json) {
    return RestAction(
      name: json['name']?.toString() ?? '',
      uriKey: json['uriKey']?.toString() ?? '',
      fields: _rulesMap(json['fields']),
      meta: (json['meta'] as Map?)?.cast<String, dynamic>(),
      isStandalone: json['is_standalone'] == true,
    );
  }
}

class RestInstruction {
  final String name;
  final String uriKey;
  final Map<String, List<String>> fields;
  final Map<String, dynamic>? meta;

  const RestInstruction({
    required this.name,
    required this.uriKey,
    required this.fields,
    this.meta,
  });

  factory RestInstruction.fromJson(Map<String, dynamic> json) {
    return RestInstruction(
      name: json['name']?.toString() ?? '',
      uriKey: json['uriKey']?.toString() ?? '',
      fields: _rulesMap(json['fields']),
      meta: (json['meta'] as Map?)?.cast<String, dynamic>(),
    );
  }
}

Map<String, List<String>> _rulesMap(dynamic json) {
  if (json is! Map) return const {};
  final map = json.cast<String, dynamic>();
  return map.map((k, v) {
    final rules = (v is List)
        ? v.map((e) => e.toString()).toList()
        : <String>[];
    return MapEntry(k, rules);
  });
}
