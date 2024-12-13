import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:invitations_project/domain/invitation_view/repository/invitation_view_repository_interface.dart';

@LazySingleton(
  as: InvitationViewRepositoryInterface,
  env: [Environment.prod],
)
class ProductionInvitationViewRepository
    implements InvitationViewRepositoryInterface {
  @override
  Future<Either<Failure, Invitation>> loadInvitation(UniqueId id) {
    // TODO: implement loadInvitation
    throw UnimplementedError();
  }
}
