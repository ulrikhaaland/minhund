import 'package:minhund/model/partner/partner.dart';
import 'package:minhund/provider/crud_provider.dart';

class PartnerProvider extends CrudProvider {
  Future<void> updateOffers({Partner model}) {
    return firestoreInstance
        .collection("partnerOffers")
        .where("partnerId", isEqualTo: model.id)
        .getDocuments()
        .then((qSnap) {
      qSnap.documents.forEach((doc) {
        doc.reference.updateData({
          "partner": model.toJson(),
        });
      });
    });
  }
}
