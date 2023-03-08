import 'package:equatable/equatable.dart';

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'No Cache';
}

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class FailureToMessage {
  static String mapFailureToMessage(Failure failure) {
    var message = 'An Error occurred, please try again';
    if (failure is NoInternetFailure) {
      message = 'Please check your internet connection and try again';
    } else if (failure is ServerFailure) {
      message = failure.message;
    } else if (failure is CacheFailure || failure is NoEntityFailure) {
      message = 'Entity no found, please try again';
    } else if (failure is PendingFailure) {
      message = 'Request is pending, please try again later';
    } else if (failure is UpdateRequiredFailure) {
      message = failure.message ?? 'Update required';
    } else if (failure is UnknownFailure) {
      message = failure.message ?? 'Unknown failure';
    }
    return message;
  }
}

class Maintenance extends Failure {
  final String message;

  const Maintenance({required this.message});

  @override
  List<Object> get props => [message];
}

class NoEntityFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'No Entity';
}

class NoInternetFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'No internet';
}

class NullFailure extends Failure {
  @override
  List<Object> get props => [];
}

class PendingFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Pending Failure';
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class SessionTimeOut extends Failure {
  final String message;

  const SessionTimeOut({required this.message});

  @override
  List<Object> get props => [message];
}

class UnknownFailure extends Failure {
  final String? message;

  const UnknownFailure({this.message});

  @override
  List<Object> get props => [message!];

  @override
  String toString() => 'Unknown Failure';
}

class UpdateRequiredFailure extends Failure {
  final String? message;

  const UpdateRequiredFailure({this.message});

  @override
  List<Object?> get props => [message];
}
