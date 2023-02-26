

class OpeningTime{

  List<List<double>> hours = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
  ];
  List<bool> continued = [true, true, true, true, true, true, true];

  List<int> allHours = [0] + List<int>.generate(24, (i) => i + 1);
  List<int> allMinutes = [0, 15, 30, 45];

  List<int> checkFuture(int i, List<double> hours) {
    List<int> ret = allHours;
    if (i == 0) {
      return ret;
    }
    for(var k in ret) {
      if(k < hours[i - 1]) {
        ret.remove(k);
      }
    }
    return ret;
  }


  String weekDay(int i) {
    switch(i) {
      case 0:
        return "Monday";
      case 1:
        return "Tuesday";
      case 2:
        return "Wednesday";
      case 3:
        return "Thursday";
      case 4:
        return "Friday";
      case 5:
        return "Saturday";
      case 6:
        return "Sunday";
      default:
        return "Week";
    }
  }
}


List<List<double>> initializeHours() {
  return [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
  ];
}

List<bool> initializeTurns() {
  return [true, true, true, true, true, true, true];
}

