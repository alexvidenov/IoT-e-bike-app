import 'package:ble_app/src/utils/StreamListener.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

mixin OnShouldLockPageViewScroll {
  void shouldScroll(bool shouldScroll);
}

abstract class PageViewWidget extends StatefulWidget {
  List<Widget> get pages;

  void handlePageChange(int index) {}

  AppBar buildAppBar(BuildContext context) => null;

  Widget buildDrawer(BuildContext context) => null;

  List<GButton> buildTabs();

  const PageViewWidget();

  @override
  PageViewWidgetState createState() => PageViewWidgetState();
}

class PageViewWidgetState<T extends PageViewWidget> extends State<T> {
  int _currentTab = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final pageController = PageController();

  bool _shouldScroll = true;

  List<Widget> _cachedWidgets = [];

  void _pageChanged(int index) {
    widget.handlePageChange(index);
    setState(() => _currentTab = index);
  }

  void refreshWithShouldScroll({bool shouldScroll}) =>
      setState(() => _shouldScroll = shouldScroll);

  Widget _buildPageView() => PageView.builder(
        physics: _shouldScroll
            ? const ScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: pageController,
        onPageChanged: (index) => _pageChanged(index),
        itemCount: widget.pages.length,
        itemBuilder: (_, index) {
          if (_cachedWidgets.length > index) {
            return _cachedWidgets[index];
          } else {
            final curWidget = widget.pages[index];
            _cachedWidgets.add(curWidget);
            return curWidget;
          }
        },
      );

  void bottomTapped(int index) {
    widget.handlePageChange(index);
    setState(() {
      _currentTab = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => onWillPop(context),
        child: DefaultTabController(
          length: widget.pages.length,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.black,
            appBar: widget.buildAppBar(context),
            drawer: widget.buildDrawer(context),
            body: listener(_buildPageView()) ?? _buildPageView(),
            bottomNavigationBar: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: -10,
                          blurRadius: 60,
                          color: Colors.black.withOpacity(.4),
                          offset: Offset(0, 25))
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
                  child: GNav(
                      gap: 8,
                      activeColor: Colors.white30,
                      iconSize: 24,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeOutExpo,
                      tabBackgroundColor: Colors.lightBlue,
                      textStyle:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      tabs: [...widget.buildTabs()],
                      selectedIndex: _currentTab,
                      onTabChange: (index) => bottomTapped(index)),
                ),
              ),
            ),
          ),
        ),
      );

  StreamListener listener<T>(Widget child) => null;

  Future<bool> onWillPop(BuildContext context) => Future.value(true);

  @override
  void shouldScroll(bool shouldScroll) {}
}
