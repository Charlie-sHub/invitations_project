import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:invitations_project/core/error/failure.dart';
import 'package:invitations_project/domain/core/entities/invitation.dart';
import 'package:invitations_project/domain/home/repository/home_repository_interface.dart';

@LazySingleton(
  as: HomeRepositoryInterface,
  env: [Environment.prod],
)
class ProductionHomeRepository implements HomeRepositoryInterface {
  @override
  Future<Either<Failure, List<Invitation>>> getExampleInvitations() {
    // TODO: implement getExampleInvitations
    throw UnimplementedError();
  }
}
