import 'package:dartz/dartz.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';

/// Repository for the [Invitation] edition.
@Deprecated("As saving the invitation requires a successful purchase saveInvitation has been added to the CartRepositoryInterface, use that one")
abstract class InvitationEditionRepositoryInterface {
  /// Saves an Invitation, whether new or an edited old one
  Future<Either<Failure, Unit>> saveInvitation(Invitation invitation);
}
