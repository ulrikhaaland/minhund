import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsProvider {
  Future recursiveDelete(String path) {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'recursiveDelete',
    );
    return callable.call(<String, dynamic>{"path": path});
  }
}
