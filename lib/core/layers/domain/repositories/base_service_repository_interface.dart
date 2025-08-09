abstract interface class BaseServiceRepositoryInterface {
  Future<void> create(
      {required String uri,
      required String docId,
      required Map<String, dynamic> model});

  Future<List<Map<String, dynamic>>> getAll(String uri);

  // Conditional getAll function where (field_name == fieldValue)
  Future<List<Map<String, dynamic>>> getAllWhereEquals(
      {required String uri,
      required String fieldName,
      required dynamic fieldValue});

  // Conditional getAll function where (field_name != fieldValue)
  Future<List<Map<String, dynamic>>> getAllWhereNotEquals(
      {required String uri,
      required String fieldName,
      required dynamic fieldValue});

  Future<Map<String, dynamic>?> getOne(
      {required String uri, required String docId});

  Future<void> update(
      {required String uri,
      required String docId,
      required Map<String, dynamic> model});

  Future<void> updateValue(
      {required String uri,
      required String docId,
      required String fieldName,
      required dynamic value});

  Future<void> delete({required String uri, required String docId});

  Future<List<Map<String, dynamic>>> getFromIds(
      {required String uri, required List<String> docIds});

  Future<Map<String, dynamic>?> getLatest(
      {required String uri, required String orderingField});

  Future<int?> getCountAll(String uri);

  Future<int?> getCountWhereEquals(
      {required String uri,
      required String fieldName,
      required String fieldValue});

  Future<int?> getCountWhereNotEquals(
      {required String uri,
      required String fieldName,
      required dynamic fieldValue});
}
