mixin DataConversionMixin {
  T? fromMapToModel<T>(
    Map<String, dynamic>? map,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    return map != null ? fromMap(map) : null;
  }

  List<T> fromListOfMapToListOfModel<T>(List<Map<String, dynamic>> mapList,
      T Function(Map<String, dynamic>) fromMap) {
    return mapList.map((e) => fromMap(e)).toList();
  }

  Stream<T> fromStreamOfMapToStreamOfModel<T>(
      Stream<Map<String, dynamic>> Function() stream,
      T Function(Map<String, dynamic>) fromMap) async* {
    await for (final map in stream()) {
      yield fromMap(map);
    }
  }
}
