part of bloc;

enum Endpoint { Unknown, DevicesScreen, AuthScreen }

@lazySingleton
class EntryEndpointBloc extends Bloc<Endpoint, Endpoint> {
  final DevicesBloc _devicesBloc;
  final SettingsBloc _settingsBloc;

  EntryEndpointBloc(this._devicesBloc, this._settingsBloc);

  _listen() => _devicesBloc.pickedDevice.listen((_) {
        this.pause();
        _devicesBloc.pause();
        addEvent(Endpoint.AuthScreen);
      });

  @override
  create() {
    super.create();
    _determineEndpoint();
  }
}
