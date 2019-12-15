import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/provider/crud_provider.dart';

class FCMProvider extends CrudProvider {
  @override
  Future<DocumentReference> create({model, String id}) {
    return super.create(model: model, id: id);
  }
}
