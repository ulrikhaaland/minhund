import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/model/offer.dart';
import 'package:minhund/provider/crud_provider.dart';

class OfferProvider extends CrudProvider {
  @override
  Future<List<Offer>> getCollection({String id}) async {
    QuerySnapshot qSnap = await super.getCollection(id: id);
    List<Offer> list = <Offer>[];
    if (qSnap.documents.isNotEmpty)
      for (DocumentSnapshot doc in qSnap.documents) {
        Offer offer = Offer.fromJson(doc.data);
        offer.docRef = doc.reference;
        list.add(offer);
      }
    return list;
  }
}
