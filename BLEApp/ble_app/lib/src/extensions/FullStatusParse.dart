part of '../blocs/fullStatusBloc.dart';

extension FullStatusParse on FullStatusBloc {
  List<FullStatusDataModel> _generateFullStatus(String rawData) {
    final fullStatus = <FullStatusDataModel>[];

    int counter = 0;

    String status = '${rawData[0]}';
    print("Status: " + status + '\n');
    if (status == '4') {
      print('Oh shit');
    }
    String typeOfCommand = '${rawData[1]}';

    List<String> splitObject = rawData.split('  ');

    for (int i = splitObject.length - 2; i >= 0; i--) {
      print(splitObject[i]);
      List<String> splitInner = splitObject[i].split(' ');
      for (int j = 0; j < splitInner.length; j++) {
        if (splitInner[j] != '' && splitInner[j].length != 2) {
          counter++;
          fullStatus.add(FullStatusDataModel(
              x: counter,
              y: double.parse(splitInner[j]),
              color: Colors.lightBlueAccent));
        }
      }
    }
    return fullStatus;
  }
}
