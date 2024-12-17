import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

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

  @override
  Future<Either<Failure, Unit>> deleteInvitation(UniqueId id) {
    // TODO: implement deleteInvitation
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> saveInvitation(Invitation invitation) {
    // TODO: implement saveInvitation
    throw UnimplementedError();
  }
}
