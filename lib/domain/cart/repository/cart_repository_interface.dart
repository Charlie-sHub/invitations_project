import 'package:dartz/dartz.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

/// Repository for the cart.
abstract class CartRepositoryInterface {
  /// Requests a payment
  // This might require a collection of the items to be purchased,
  // but in the meanwhile we're assuming only one Invitation at a time can be purchased
  Future<Either<Failure, Unit>> purchase();

  /// Saves an Invitation, whether new or an edited old one
  Future<Either<Failure, Unit>> saveInvitation(Invitation invitation);


  /// Deletes an Invitation by the given id
  Future<Either<Failure, Unit>> deleteInvitation(UniqueId id);
}
