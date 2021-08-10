class Time {
  int hour;
  int minutes;

  Time({this.hour, this.minutes});

  Time.fromString(String time) {
    List split = time.split(":");
    for (int i = 0; i < split.length; i++) {
      String part = split[i];
      if (part.length > 2) {
        print("NOT VALID TIME! - CANT PARSE IN CONSTRUCTOR");
      }
      switch (i) {
        case (0):
          int hour1 = int.parse(part[0]);
          int hour2 = int.parse(part[1]);
          hour = hour1 * 10 + hour2;
          break;
        case (1):
          int minutes1 = int.parse(part[0]);
          int minutes2 = int.parse(part[1]);
          minutes = minutes1 * 10 + minutes2;
      }
    }
  }

  Time calculateNewTime(Time duration, Time distance) {
    int newHour = (this.hour + duration.hour + distance.hour);
    int newMintues = (this.minutes + duration.minutes + distance.minutes);
    newHour += (newMintues / 60).toInt();
    newMintues = (newMintues % 60).toInt();
    return Time(hour: newHour, minutes: newMintues);
  }

  bool isLaterThen(Time other) {
    if (this.hour > other.hour) {
      return true;
    }
    if (this.hour < other.hour) {
      return false;
    }
    if (this.minutes > other.minutes) {
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return "hour: " +
        this.hour.toString() +
        "minutes: " +
        this.minutes.toString();
  }
}
