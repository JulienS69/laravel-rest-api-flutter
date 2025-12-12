class UserPaginatedResponse {
  final int currentPage;
  final List<UserData> data;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;
  final MetaData meta;

  UserPaginatedResponse({
    required this.currentPage,
    required this.data,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
    required this.meta,
  });

  factory UserPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return UserPaginatedResponse(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      data: (json['data'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((e) => UserData.fromJson(e))
          .toList(),
      from: (json['from'] as num?)?.toInt() ?? 0,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 0,
      to: (json['to'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      meta: MetaData.fromJson(
        (json['meta'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'data': data.map((item) => item.toJson()).toList(),
    'from': from,
    'last_page': lastPage,
    'per_page': perPage,
    'to': to,
    'total': total,
    'meta': meta.toJson(),
  };
}

class UserData {
  final int id;
  final String name;
  final Gates gates;

  UserData({required this.id, required this.name, required this.gates});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      gates: Gates.fromJson(
        (json['gates'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'gates': gates.toJson(),
  };
}

class Gates {
  final GateValue authorizedToView;
  final GateValue authorizedToUpdate;
  final GateValue authorizedToDelete;
  final GateValue authorizedToRestore;
  final GateValue authorizedToForceDelete;

  Gates({
    required this.authorizedToView,
    required this.authorizedToUpdate,
    required this.authorizedToDelete,
    required this.authorizedToRestore,
    required this.authorizedToForceDelete,
  });

  factory Gates.fromJson(Map<String, dynamic> json) {
    return Gates(
      authorizedToView: GateValue.fromJson(json['authorized_to_view']),
      authorizedToUpdate: GateValue.fromJson(json['authorized_to_update']),
      authorizedToDelete: GateValue.fromJson(json['authorized_to_delete']),
      authorizedToRestore: GateValue.fromJson(json['authorized_to_restore']),
      authorizedToForceDelete: GateValue.fromJson(
        json['authorized_to_force_delete'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'authorized_to_view': authorizedToView.toJson(),
    'authorized_to_update': authorizedToUpdate.toJson(),
    'authorized_to_delete': authorizedToDelete.toJson(),
    'authorized_to_restore': authorizedToRestore.toJson(),
    'authorized_to_force_delete': authorizedToForceDelete.toJson(),
  };
}

class MetaData {
  final MetaGates gates;

  MetaData({required this.gates});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      gates: MetaGates.fromJson(
        (json['gates'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {'gates': gates.toJson()};
}

class MetaGates {
  final GateValue authorizedToCreate;

  MetaGates({required this.authorizedToCreate});

  factory MetaGates.fromJson(Map<String, dynamic> json) {
    return MetaGates(
      authorizedToCreate: GateValue.fromJson(json['authorized_to_create']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'authorized_to_create': authorizedToCreate.toJson()};
  }
}

class GateValue {
  final bool allowed;
  final String? message;

  const GateValue({required this.allowed, this.message});

  /// Accepts either:
  /// - `true` / `false`
  /// - `{ "allowed": bool, "message": "..." }`
  factory GateValue.fromJson(dynamic json) {
    if (json is bool) {
      return GateValue(allowed: json);
    }

    if (json is Map<String, dynamic>) {
      return GateValue(
        allowed: json['allowed'] as bool? ?? false,
        message: json['message'] as String?,
      );
    }

    throw ArgumentError('Invalid gate value: $json');
  }

  /// If there is no message, return a pure bool (to keep API compatible).
  /// If there is a message, return `{ allowed, message }`.
  dynamic toJson() {
    if (message == null) {
      return allowed;
    }

    return {'allowed': allowed, 'message': message};
  }
}
