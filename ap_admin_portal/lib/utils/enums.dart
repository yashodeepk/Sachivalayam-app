final taskStatusValues = EnumValues({
  'Ongoing': TaskStatus.ongoing,
  "In-review": TaskStatus.inReview,
  'Completed': TaskStatus.completed,
  // 'Pending': TaskStatus.pending,
  'all': TaskStatus.all,
  // 'Approved': TaskStatus.approved,
});

final userRoleValues = EnumValues({
  'ROLE_SECRETARY': UserRole.roleSecretary,
  'ROLE_SANITARYINSPECTOR': UserRole.roleSanitaryInspector,
});

enum AnimateType { slideLeft, slideUp }

enum AppImageSource { camera, gallery }

enum AppTextFieldType { regular, phone, search, multiline, form }

enum AuthState { initial, loggedInWithValidJwt, notLoggedIn, loggedInWithExpiredJwt }

enum BaseModelState { initial, loading, success, error }

enum ButtonType { initial, pressed }

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));

    return reverseMap!;
  }
}

enum IndicatorType { top, bottom }

enum LoadingState { initial, loading, loaded, error }

//to add remaining
enum RequestType {
  get,
  post,
  put,
  patch,
  delete,
}

enum ScreenSize { large, medium, small }

enum TaskStatus { all, ongoing, inReview, completed }

enum UserRole { roleSanitaryInspector, roleSecretary, roleAdmin }
