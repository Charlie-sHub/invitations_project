import 'package:dartz/dartz.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';

/// Repository for the [Invitation] view.
abstract class InvitationViewRepositoryInterface {
  /// Loads an Invitation by its id
  Future<Either<Failure, Invitation>> loadInvitation(UniqueId id);
}
