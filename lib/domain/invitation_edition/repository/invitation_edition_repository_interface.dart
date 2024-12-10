import 'package:dartz/dartz.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';

/// Repository for the [Invitation] edition.
abstract class InvitationEditionRepositoryInterface {
  /// Saves an Invitation, whether new or an edited old one
  Future<Either<Failure, Unit>> saveInvitation(Invitation invitation);
}
