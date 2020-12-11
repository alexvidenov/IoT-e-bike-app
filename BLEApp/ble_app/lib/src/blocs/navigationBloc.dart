part of bloc;

enum CurrentPage { Short, Full, Map }

@lazySingleton
class NavigationBloc extends Bloc<CurrentPage, CurrentPage> {
  final NavigationService _navigationService;

  NavigationBloc(this._navigationService) : super();

  GlobalKey<NavigatorState> get navigatorKey =>
      _navigationService.innerNavigatorKey;
}

extension NavigationMethods on NavigationBloc {
  navigateTo(String routeName) => _navigationService.innerNavigateTo(routeName);

  returnToFirstRoute() => _navigationService.returnToFirstInner();

  generateGlobalKey() => _navigationService.generateGlobalKey();

}
