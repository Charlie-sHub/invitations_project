import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/data/core/misc/get_valid_invitation.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/home/repository/home_repository_interface.dart';

@LazySingleton(
  as: HomeRepositoryInterface,
  env: [Environment.dev],
)
class DevelopmentHomeRepository implements HomeRepositoryInterface {
  @override
  Future<Either<Failure, Set<Invitation>>> getExampleInvitations() async {
    return right(
      {
        getValidInvitation(),
        getValidInvitation(),
        getValidInvitation(),
        getValidInvitation(),
        getValidInvitation(),
        getValidInvitation(),
      },
    );
  }
}
