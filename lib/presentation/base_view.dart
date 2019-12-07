import 'package:flutter/material.dart';

import './base_controller.dart';

abstract class BaseView extends StatefulWidget {
  const BaseView({
    this.controller,
    Key key,
  }) : super(key: key);

  final BaseController controller;

  @override
  createState() {
    /// Pass this 'view' to a State object.
    var state = new BaseState(this, controller);

    /// Get a reference of the State object for the Controller.
    controller?.state = state;

    return state;
  }

  /// Allow for the widget getter in the build() function.
  BaseView get widget => this;

  /// BuildContext is always useful in the build() function.
  BuildContext get context => controller.state.context ?? createState().context;

  /// Ensure the State Object is 'mounted' and not being terminated.
  bool get mounted => controller.state.mounted ?? createState().mounted;

  /// Provide 'the view'
  Widget build(BuildContext context);
}

/// The State Object
class BaseState extends State<BaseView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  BaseState(
    this.view,
    this._controller,
  );

  final BaseView view;

  final BaseController _controller;

  get buildWidget => _build;
  Widget _build;

  @override
  void initState() {
    /// called when the [State] object is first created.
    super.initState();

    _controller?.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void deactivate() {
    /// called when this [State] object is removed from the tree.
    _controller?.deactivate();
    super.deactivate();
  }

  bool _disposed = false;

  @override
  void dispose() {
    /// called when this [State] object will never build again.
    _disposed = true;

    _build = null;
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BaseView oldWidget) {
    /// Override this method to respond when the [widget] changes (e.g., to start
    /// implicit animations).
    /// The framework always calls [build] after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
    super.didUpdateWidget(oldWidget);
    _controller?.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing either the values AppLifecycleState.paused or AppLifecycleState.resumed.
    _controller?.didChangeAppLifecycleState(state);
  }

  void reState(VoidCallback fn) {
    /// Calls the 'real' setState()
    /// setState() can only be called within this class.
    if (!_disposed) {
      setState(fn);
    }
  }

  /// The View
  Widget build(BuildContext context) {
    if (!mounted) {
      return new Container();
    }

    /// Here's where the magic happens.
    _build = view.build(context);
    return _build;
  }
}
