import 'package:minhund/helper/helper.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:flutter/material.dart';

abstract class LinkedSearchBarManager {
  String get currentSearch;
  set currentSearch(String search);
  void currentSearchRemoved();
  void searchTriggered(String search);
}

class AppbarSearchBar extends StatefulWidget {
  final LinkedSearchBarManager linkedSearchBarManager;
  final double searchbarWidth;

  AppbarSearchBar({
    @required this.linkedSearchBarManager,
    @required this.searchbarWidth,
  });

  @override
  State<StatefulWidget> createState() => _AppbarSearchBar();
}

class _AppbarSearchBar extends State<AppbarSearchBar> {
  bool _showSearchBar = false;

  bool _showRemoveIcon = false;

  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return new Container();
    }

    if (!_showSearchBar) {
      return _buildIcon(context);
    }

    /// Get the current search text so that this appbar searchbar
    /// can be integrated with other search bars for the same purpose
    /// within the same page such as the [FilterController].
    if (_textController.text != widget.linkedSearchBarManager.currentSearch) {
      _textController.text = widget.linkedSearchBarManager.currentSearch;
    }

    return new LayoutBuilder(
      builder: (con, constraints) {
        return Container(
          width: widget.searchbarWidth,
          height: constraints.maxHeight,
          margin: EdgeInsets.only(
            bottom: getDefaultPadding(context),
            top: getDefaultPadding(context),
          ),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(getDefaultPadding(context)),
            color: Colors.black.withAlpha(50),
          ),
          child: new Padding(
            padding: EdgeInsets.only(
              left: getDefaultPadding(context),
              right: getDefaultPadding(context) * 0.5,
            ),
            child: new TextField(
              autocorrect: false,
              autofocus: true,
              style: ServiceProvider
                  .instance.instanceStyleService.appStyle.body1
                  .copyWith(
                color: Colors.white,
              ),
              controller: _textController,
              decoration: new InputDecoration(
                border: InputBorder.none,
                suffixIcon: _showRemoveIcon
                    ? new GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.linkedSearchBarManager
                                .currentSearchRemoved();
                            _textController.text = "";

                            _showRemoveIcon = false;
                          });
                        },
                        child: new Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: constraints.maxHeight * 0.5,
                        ),
                      )
                    : null,
              ),
              onChanged: (s) {
                setState(() {
                  widget.linkedSearchBarManager.currentSearch =
                      _textController.text;
                  _showRemoveIcon = s != null && s.length > 0;
                });
              },
              onSubmitted: (text) {
                widget.linkedSearchBarManager.searchTriggered(text);

                /// Search has been triggered so force a
                /// re-state so that the bar is hidden
                setState(() {
                  _showSearchBar = false;
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(right: 0.0),
      child: new IconButton(
        onPressed: () {
          setState(
            () {
              _showSearchBar = !_showSearchBar;
            },
          );
        },
        icon: new Icon(
          Icons.search,
          size: getAppBarIconSize(context),
          color: Colors.white,
        ),
      ),
    );
  }
}
