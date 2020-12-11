part of bloc;

@injectable
class FullStatusBloc extends Bloc<List<FullStatusDataModel>, String> {
  final DeviceRepository _repository;

  FullStatusBloc(this._repository) : super();

  @override
  _create() => _listenToFullStatus();

  @override
  _pause() {
    _repository.cancel();
    _pauseSubscription();
  }

  @override
  _resume() {
    _repository.resumeTimer(false); // change this boolean to  enum please
    _resumeSubscription();
  }

  _listenToFullStatus() {
    streamSubscription = _repository.characteristicValueStream.listen(
        (event) => // if(event.length > someArbitrary shit). This probably won't be needed.
            addEvent(_generateFullStatusDataModel(_generateFullStatus(event))));
  }
}
