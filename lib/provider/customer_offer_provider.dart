import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/provider/crud_provider.dart';

class CustomerOfferProvider extends CrudProvider {
  @override
  Future getCollection({String id}) async {
    QuerySnapshot qSnap = await super.getCollection(id: id);
  }
}
