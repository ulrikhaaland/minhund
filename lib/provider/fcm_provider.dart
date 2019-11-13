import 'package:minhund/provider/crud_provider.dart';

class FCMProvider extends CrudProvider {
  @override
  Future create({model, String id}) {
    return super.create(model: model, id: id);
  }
}
