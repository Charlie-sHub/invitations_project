import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/cart/repository/cart_repository_interface.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

@LazySingleton(
  as: CartRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentCartRepository implements CartRepositoryInterface {
  @override
  Future<Either<Failure, Unit>> purchase() async {
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteInvitation(UniqueId id) async {
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> saveInvitation(Invitation invitation) async {
    return right(unit);
  }
}
