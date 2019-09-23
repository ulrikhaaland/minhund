import 'package:meta/meta.dart';

class SetLoadingEvent {
  final String message;
  final bool loading;
  final Object object;

  SetLoadingEvent({
    @required this.loading,
    @required this.object,
    this.message,
  }) {
    if (loading == null) {
      throw Exception("loading != null is not true");
    }

    if (object == null) {
      throw Exception("object != null is not true");
    }
  }
}
