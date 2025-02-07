// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_restaurant_rating.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _RepoRestaurantRating implements RepoRestaurantRating {
  _RepoRestaurantRating(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<CursorPagination<MRating>> paginate(
      {PaginationParams? paginationParams}) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(paginationParams?.toJson() ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'accessToken': 'true'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<CursorPagination<MRating>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CursorPagination<MRating> _value;
    try {
      _value = CursorPagination<MRating>.fromJson(
        _result.data!,
        (json) => MRating.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$repoRestaurantRatingHash() =>
    r'280578337e9044a00227ebfd9ae4c45d2299d7f9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [repoRestaurantRating].
@ProviderFor(repoRestaurantRating)
const repoRestaurantRatingProvider = RepoRestaurantRatingFamily();

/// See also [repoRestaurantRating].
class RepoRestaurantRatingFamily extends Family<RepoRestaurantRating> {
  /// See also [repoRestaurantRating].
  const RepoRestaurantRatingFamily();

  /// See also [repoRestaurantRating].
  RepoRestaurantRatingProvider call(
    String id,
  ) {
    return RepoRestaurantRatingProvider(
      id,
    );
  }

  @override
  RepoRestaurantRatingProvider getProviderOverride(
    covariant RepoRestaurantRatingProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'repoRestaurantRatingProvider';
}

/// See also [repoRestaurantRating].
class RepoRestaurantRatingProvider
    extends AutoDisposeProvider<RepoRestaurantRating> {
  /// See also [repoRestaurantRating].
  RepoRestaurantRatingProvider(
    String id,
  ) : this._internal(
          (ref) => repoRestaurantRating(
            ref as RepoRestaurantRatingRef,
            id,
          ),
          from: repoRestaurantRatingProvider,
          name: r'repoRestaurantRatingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$repoRestaurantRatingHash,
          dependencies: RepoRestaurantRatingFamily._dependencies,
          allTransitiveDependencies:
              RepoRestaurantRatingFamily._allTransitiveDependencies,
          id: id,
        );

  RepoRestaurantRatingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    RepoRestaurantRating Function(RepoRestaurantRatingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RepoRestaurantRatingProvider._internal(
        (ref) => create(ref as RepoRestaurantRatingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<RepoRestaurantRating> createElement() {
    return _RepoRestaurantRatingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RepoRestaurantRatingProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RepoRestaurantRatingRef on AutoDisposeProviderRef<RepoRestaurantRating> {
  /// The parameter `id` of this provider.
  String get id;
}

class _RepoRestaurantRatingProviderElement
    extends AutoDisposeProviderElement<RepoRestaurantRating>
    with RepoRestaurantRatingRef {
  _RepoRestaurantRatingProviderElement(super.provider);

  @override
  String get id => (origin as RepoRestaurantRatingProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
