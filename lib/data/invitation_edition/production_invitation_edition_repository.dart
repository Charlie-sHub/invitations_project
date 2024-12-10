import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/invitation_edition/repository/invitation_edition_repository_interface.dart';

@LazySingleton(
  as: InvitationEditionRepositoryInterface,
  env: [Environment.prod],
)
class ProductionInvitationEditionRepository
    implements InvitationEditionRepositoryInterface {
  @override
  Future<Either<Failure, Unit>> saveInvitation(Invitation invitation) {
    // TODO: implement saveInvitation
    throw UnimplementedError();
  }
}
