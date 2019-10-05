import 'package:minhund/provider/crud_provider.dart';

class JournalProvider extends CrudProvider {
  @override
  Future update({model}) {
    return super.update(model: model);
  }

  @override
  Future get({String id}) {
    return super.get(id: id);
  }

  @override
  Future create({model, String id}) {
    return super.create(model: model, id: id);
  }

  @override
  Future getCollection({String id}) {
    return super.getCollection(id: id);
  }

  @override
  Future delete({model}) {
    return super.delete(model: model);
  }

  @override
  Future set({String id, model}) {
    return super.set(id: id, model: model);
  }
}
