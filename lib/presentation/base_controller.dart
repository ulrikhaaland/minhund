import 'package:flutter/material.dart';

import './base_view.dart';

/// The Controller
class BaseController {
  BaseController();

  /// A reference to the State object.
  BaseState state;

  /// Allow for the widget getter in the build() function.
  BaseView get widget => state?.view;

  /// BuildContext is always useful in the build() function.
  BuildContext get context => state?.context;

  /// Ensure the State Object is 'mounted' and not being terminated.
  bool get mounted => state?.mounted;

  /// Flag for the initialised state of the object
  bool initialized = false;

  /// The framework will call this method exactly once.
  /// Only when the [State] object is first created.
  ///
  /// Override this method to perform initialization that depends on the
  /// location at which this object was inserted into the tree.
  /// (i.e. Subscribe to another object it depends on during [initState],
  /// unsubscribe object and subscribe to a new object when it changes in
  /// [didUpdateWidget], and then unsubscribe from the object in [dispose].
  void initState() {
    if (!(initialized ?? true)) {
      superInitState();

      initialized = true;
    }
  }

  /// The framework will call initState when the StatefulWidget's state is
  /// created. However a controller can have another life cycle than its
  /// state resulting in multiple initialisations of objects. This function will
  /// only be called once for a controller object and it is tied up with the
  /// frameworks initState
  void superInitState() {}

  /// The framework calls this method whenever it removes this [State] object
  /// from the tree. It might reinsert it into another part of the tree.
  /// Subclasses should override this method to clean up any links between
  /// this object and other elements in the tree (e.g. if you have provided an
  /// ancestor with a pointer to a descendant's [RenderObject]).
  void deactivate() {}

  /// The framework calls this method when this [State] object will never
  /// build again. The [State] object's lifecycle is terminated.
  /// Subclasses should override this method to release any resources retained
  /// by this object (e.g., stop any active animations).
  void dispose() {}

  void didUpdateWidget(BaseView oldWidget) {}

  void didChangeAppLifecycleState(AppLifecycleState state) {}

  void setState(VoidCallback fn) {
    if (!(mounted ?? false)) {
      return;
    }

    /// Call the State object's setState() function.
    state?.reState(fn);
  }

  void refresh() {
    /// Refresh the Widget Tree Interface
    state?.reState(() {});
  }
}
