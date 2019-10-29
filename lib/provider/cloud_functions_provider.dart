import 'package:cloud_functions/cloud_functions.dart';

enum UserType { partner, user }

class CloudFunctionsProvider {
  Future recursiveDelete({String pathAfterTypeId, UserType userType}) {
    String type = "users";
    switch (userType) {
      case UserType.user:
        type = "users";
        break;
      case UserType.partner:
        type = "partners";
        break;
    }
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'recursiveDelete',
    );
    return callable
        .call(<String, dynamic>{"path": pathAfterTypeId, "type": type});
  }
}
