abstract interface class Usecase<Type,Params>{
  Future<Type> call(Params params);
}

abstract interface class UsecaseWithoutParams<Type>{
  Future<Type> call();
}

