import 'package:injectable/injectable.dart';

// import '../core/errors/error.dart';
import 'network/networkInfo.dart';

@LazySingleton(as: AsyncFunctionWrapper)
class AsyncFunctionImpl extends AsyncFunctionWrapper {
  NetworkInfo networkInfo;

  AsyncFunctionImpl(this.networkInfo);

  @override
  Future handleAsyncNetworkCall(Function() asyncMethod) async {
    if (await networkInfo.isConnected) {
      return await asyncMethod();
    } else {
      // throw NoInternetException();
    }
  }
}

///Use this to handle network calls in all data source
abstract class AsyncFunctionWrapper {
  Future handleAsyncNetworkCall(Function() asyncMethod);
}
