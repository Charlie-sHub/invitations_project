import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';

@LazySingleton(
  as: CartRepositoryInterface,
  env: [Environment.prod],
)
class ProductionCartRepository implements CartRepositoryInterface {
  @override
  Future<Either<Failure, Unit>> purchase() {
    // TODO: implement purchase
    throw UnimplementedError();
  }

}
