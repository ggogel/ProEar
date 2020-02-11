class SensorSet {
  String name;
  int count = 0;
  int currentMatches = 0;
  List<List<double>> accelerationList;
  List<List<double>> gyroList;
  bool recognizeEnabled;
  bool accelerationEnabled;
  bool gyroEnabled;

  SensorSet(
      this.name, this.accelerationList, this.gyroList, this.accelerationEnabled, this.gyroEnabled, this.recognizeEnabled);
}
