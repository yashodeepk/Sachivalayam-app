

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Env {
  @EnviedField(defaultValue: 'http://ec2-65-0-138-213.ap-south-1.compute.amazonaws.com', obfuscate: true)
  static final server = _Env.server;

  @EnviedField(defaultValue: 'http://ec2-65-0-138-213.ap-south-1.compute.amazonaws.com/api', obfuscate: true)
  static final baseurl = _Env.baseurl;

  @EnviedField(
      defaultValue: '#c?wns?31@0L8!js;jytv]MtbAsAZ9+.', obfuscate: true)
  static final secure = _Env.secure;

  @EnviedField(defaultValue: '/auth/signin', obfuscate: true)
  static final signInEndPoint = _Env.signInEndPoint;

  @EnviedField(defaultValue: '/auth/signup', obfuscate: true)
  static final signUpEndPoint = _Env.signUpEndPoint;

  @EnviedField(defaultValue: '/todays_task', obfuscate: true)
  static final getTaskTodayEndPoint = _Env.getTaskTodayEndPoint;

  @EnviedField(defaultValue: '/getAddNewTaskDetails', obfuscate: true)
  static final getNewTaskDetailsEndPoint = _Env.getNewTaskDetailsEndPoint;

  @EnviedField(defaultValue: '/task', obfuscate: true)
  static final taskEndPoint = _Env.taskEndPoint;

  @EnviedField(defaultValue: '/task_by_id', obfuscate: true)
  static final getTaskByIdEndPoint = _Env.getTaskByIdEndPoint;

  @EnviedField(defaultValue: '/task_by_status', obfuscate: true)
  static final getTaskStatusEndPoint = _Env.getTaskStatusEndPoint;

  @EnviedField(defaultValue: '/user/worker', obfuscate: true)
  static final getWorkersEndPoint = _Env.getWorkersEndPoint;

  @EnviedField(defaultValue: '/user', obfuscate: true)
  static final userEndPoint = _Env.userEndPoint;

  @EnviedField(defaultValue: '/getdownloadlink', obfuscate: true)
  static final getDownloadLinkEndPoint = _Env.getDownloadLinkEndPoint;
}
