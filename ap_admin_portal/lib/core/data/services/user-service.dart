import 'package:ap_admin_portal/core/data/repository/user-repo.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../models/user/user.dart';

abstract class UserService {
  Future<Either<String, int?>> addUpdateWorker({required User user, required bool update, required String userId});
  Future<Either<String, int?>> deleteWorker({required String workerId});
  Future<Either<String, List<User>?>> getWorkers();
  User? user;
}

@LazySingleton(as: UserService)
class UserServiceImpl extends UserService {
  final UserRepository userRepository;
  var userBox = Hive.lazyBox('userDb');

  UserServiceImpl(this.userRepository);

  @override
  Future<Either<String, int?>> addUpdateWorker({required User user, required bool update, required String userId}) async {
    return await userRepository.addUpdateWorker(user: user, userId: userId, update: update);
  }

  @override
  Future<Either<String, int?>> deleteWorker({required String workerId}) async {
    return await userRepository.deleteWorker(workerId: workerId);
  }

  @override
  Future<Either<String, List<User>?>> getWorkers() async {
    return await userRepository.getWorkers();
  }
}
