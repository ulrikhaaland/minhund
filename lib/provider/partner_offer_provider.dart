import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/provider/crud_provider.dart';

class PartnerOfferProvider extends CrudProvider {
  String path = "partners/";
  @override
  Future create({model, String id}) {
    return super.create(model: model, id: id);
  }

  @override
  Future get({String id}) {
    return super.get(id: id);
  }

  @override
  Future<List<PartnerOffer>> getCollection({String id}) async {
    QuerySnapshot qSnap = await super.getCollection(id: path + id + "/offers");

    List<PartnerOffer> list = <PartnerOffer>[];

    qSnap.documents.forEach((doc) async {
      PartnerOffer partnerOffer = PartnerOffer.fromJson(doc.data);
      partnerOffer.docRef = doc.reference;
      list.add(partnerOffer);
    });

    return list;
  }
}
