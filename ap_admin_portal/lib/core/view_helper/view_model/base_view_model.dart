import 'package:flutter/widgets.dart';

import '../../../utils/enums.dart';

///REMOVE IN FUTURE
class BaseModel extends ChangeNotifier {
  BaseModelState state = BaseModelState.initial;
  Object? errorType;

  void changeState(BaseModelState value) {
    state = value;
    notifyListeners();
  }

  void setError(Object error) {
    errorType = error;
  }
}
