class BluetoothUtils {
  static final String SERVICE_UUID =
      "0000ffe0-0000-1000-8000-00805f9b34fb"; // for HM-10
  static final String CHARACTERISTIC_UUID =
      "0000ffe1-0000-1000-8000-00805f9b34fb";
}

enum ConnectionEvent { Connecting, Connected, FailedToConnect }
