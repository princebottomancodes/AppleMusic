import 'package:flutter/cupertino.dart';

class CupertinoTabController extends ChangeNotifier {
  CupertinoTabController({int initialIndex = 0})
      : _index = initialIndex,
        assert(initialIndex >= 0);

  bool _isDisposed = false;

  int get index => _index;
  int _index;
  set index(int value) {
    assert(value >= 0);
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}

class TabScaffold extends StatefulWidget {
  TabScaffold({
    Key? key,
    required this.tabBar,
    required this.tabBuilder,
    required this.miniView,
    required this.isExpanded,
    this.controller,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.restorationId,
  })  : assert(
          controller == null || controller.index < tabBar.items.length,
          "The CupertinoTabController's current index ${controller.index} is "
          'out of bounds for the tab bar with ${tabBar.items.length} tabs',
        ),
        super(key: key);

  final CupertinoTabBar tabBar;

  final Widget miniView;

  final CupertinoTabController? controller;

  final IndexedWidgetBuilder tabBuilder;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final String? restorationId;

  final bool isExpanded;

  @override
  State<TabScaffold> createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> with RestorationMixin {
  RestorableCupertinoTabController? _internalController;
  CupertinoTabController get _controller =>
      widget.controller ?? _internalController!.value;

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _restoreInternalController();
  }

  void _restoreInternalController() {
    if (_internalController != null) {
      registerForRestoration(_internalController!, 'controller');
      _internalController!.value.addListener(_onCurrentIndexChange);
    }
  }

  @override
  void initState() {
    super.initState();
    _updateTabController();
  }

  void _updateTabController([CupertinoTabController? oldWidgetController]) {
    if (widget.controller == null && _internalController == null) {
      // No widget-provided controller: create an internal controller.
      _internalController = RestorableCupertinoTabController(
          initialIndex: widget.tabBar.currentIndex);
      if (!restorePending) {
        _restoreInternalController();
      }
    }
    if (widget.controller != null && _internalController != null) {
      // Use the widget-provided controller.
      unregisterFromRestoration(_internalController!);
      _internalController!.dispose();
      _internalController = null;
    }
    if (oldWidgetController != widget.controller) {
      // The widget-provided controller has changed: move listeners.
      if (oldWidgetController?._isDisposed == false) {
        oldWidgetController!.removeListener(_onCurrentIndexChange);
      }
      widget.controller?.addListener(_onCurrentIndexChange);
    }
  }

  void _onCurrentIndexChange() {
    assert(
      _controller.index >= 0 && _controller.index < widget.tabBar.items.length,
      "The $runtimeType's current index ${_controller.index} is "
      'out of bounds for the tab bar with ${widget.tabBar.items.length} tabs',
    );

    setState(() {});
  }

  @override
  void didUpdateWidget(TabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController(oldWidget.controller);
    } else if (_controller.index >= widget.tabBar.items.length) {
      _controller.index = widget.tabBar.items.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData existingMediaQuery = MediaQuery.of(context);
    MediaQueryData newMediaQuery = MediaQuery.of(context);

    Widget content = _TabSwitchingView(
      currentTabIndex: _controller.index,
      tabCount: widget.tabBar.items.length,
      tabBuilder: widget.tabBuilder,
    );

    EdgeInsets contentPadding = EdgeInsets.zero;

    if (widget.resizeToAvoidBottomInset) {
      // Remove the view inset and add it back as a padding in the inner content.
      newMediaQuery = newMediaQuery.removeViewInsets(removeBottom: true);
      contentPadding =
          EdgeInsets.only(bottom: existingMediaQuery.viewInsets.bottom);
    }

    if ((!widget.resizeToAvoidBottomInset ||
        widget.tabBar.preferredSize.height >
            existingMediaQuery.viewInsets.bottom)) {
      final double bottomPadding = widget.tabBar.preferredSize.height +
          existingMediaQuery.padding.bottom;

      // If tab bar opaque, directly stop the main content higher. If
      // translucent, let main content draw behind the tab bar but hint the
      // obstructed area.
      if (widget.tabBar.opaque(context)) {
        contentPadding = EdgeInsets.only(bottom: bottomPadding);
        newMediaQuery = newMediaQuery.removePadding(removeBottom: true);
      } else {
        newMediaQuery = newMediaQuery.copyWith(
          padding: newMediaQuery.padding.copyWith(
            bottom: bottomPadding,
          ),
        );
      }
    }

    content = MediaQuery(
      data: newMediaQuery,
      child: Padding(
        padding: contentPadding,
        child: content,
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.maybeResolve(
                widget.backgroundColor, context) ??
            CupertinoTheme.of(context).scaffoldBackgroundColor,
      ),
      child: Stack(
        children: <Widget>[
          // The main content being at the bottom is added to the stack first.
          content,
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.miniView,
                widget.isExpanded
                    ? widget.tabBar.copyWith(
                        currentIndex: _controller.index,
                        onTap: (int newIndex) {
                          _controller.index = newIndex;
                          // Chain the user's original callback.
                          widget.tabBar.onTap?.call(newIndex);
                        },
                      )
                    : const SizedBox.shrink()
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller?._isDisposed == false) {
      _controller.removeListener(_onCurrentIndexChange);
    }
    _internalController?.dispose();
    super.dispose();
  }
}

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    required this.currentTabIndex,
    required this.tabCount,
    required this.tabBuilder,
  });

  final int currentTabIndex;
  final int tabCount;
  final IndexedWidgetBuilder tabBuilder;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  final List<bool> shouldBuildTab = <bool>[];
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];
  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];

  @override
  void initState() {
    super.initState();
    shouldBuildTab.addAll(List<bool>.filled(widget.tabCount, false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only partially invalidate the tabs cache to avoid breaking the current
    // behavior. We assume that the only possible change is either:
    // - new tabs are appended to the tab list, or
    // - some trailing tabs are removed.
    // If the above assumption is not true, some tabs may lose their state.
    final int lengthDiff = widget.tabCount - shouldBuildTab.length;
    if (lengthDiff > 0) {
      shouldBuildTab.addAll(List<bool>.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildTab.removeRange(widget.tabCount, shouldBuildTab.length);
    }
    _focusActiveTab();
  }

  void _focusActiveTab() {
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount));
        tabFocusNodes.removeRange(widget.tabCount, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount - tabFocusNodes.length,
            (int index) => FocusScopeNode(
                debugLabel: '$TabScaffold Tab ${index + tabFocusNodes.length}'),
          ),
        );
      }
    }
    FocusScope.of(context).setFirstFocus(tabFocusNodes[widget.currentTabIndex]);
  }

  @override
  void dispose() {
    for (final FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (final FocusScopeNode focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List<Widget>.generate(widget.tabCount, (int index) {
        final bool active = index == widget.currentTabIndex;
        shouldBuildTab[index] = active || shouldBuildTab[index];

        return HeroMode(
          enabled: active,
          child: Offstage(
            offstage: !active,
            child: TickerMode(
              enabled: active,
              child: FocusScope(
                node: tabFocusNodes[index],
                child: Builder(builder: (BuildContext context) {
                  return shouldBuildTab[index]
                      ? widget.tabBuilder(context, index)
                      : Container();
                }),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class RestorableCupertinoTabController
    extends RestorableChangeNotifier<CupertinoTabController> {
  RestorableCupertinoTabController({int initialIndex = 0})
      : _initialIndex = initialIndex;

  final int _initialIndex;

  @override
  CupertinoTabController createDefaultValue() {
    return CupertinoTabController(initialIndex: _initialIndex);
  }

  @override
  CupertinoTabController fromPrimitives(Object? data) {
    assert(data != null);
    return CupertinoTabController(initialIndex: data! as int);
  }

  @override
  Object? toPrimitives() {
    return value.index;
  }
}
