import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/core/validation/objects/unique_id.dart';
import 'package:invitations_project/domain/invitation_edition/repository/invitation_edition_repository_interface.dart';
import 'package:invitations_project/domain/invitation_view/repository/invitation_view_repository_interface.dart';

@LazySingleton(
  as: InvitationViewRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentInvitationViewRepository
    implements InvitationViewRepositoryInterface {

  @override
  Future<Either<Failure, Invitation>> loadInvitation(UniqueId id) async {
    return right(getValidInvitation());
  }
}
