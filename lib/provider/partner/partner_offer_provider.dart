import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhund/model/partner/partner_offer.dart';
import 'package:minhund/provider/crud_provider.dart';

class PartnerOfferProvider extends CrudProvider {
  @override
  Future<List<PartnerOffer>> getCollection({String id}) async {
    QuerySnapshot qSnap = await Firestore.instance
        .collection("partnerOffers")
        .where("partnerId", isEqualTo: id)
        .getDocuments();

    List<PartnerOffer> list = <PartnerOffer>[];

    qSnap.documents.forEach((doc) async {
      PartnerOffer partnerOffer = PartnerOffer.fromJson(doc.data);
      partnerOffer.docRef = doc.reference;
      list.add(partnerOffer);
    });

    return list;
  }
}
