extension on double {
  double get normalizedToNegative => this * 2 - 1;
}

double _normalize(num? input, num min, num max) {
  input ??= min;
  return (input - min) / (max - min);
}

class Student {
  static const jobDictionary = {
    'teacher': 0,
    'health': 1,
    'services': 2,
    'at_home': 3,
    'other': 4,
  };

  static const reasonDictionary = {
    'home': 0,
    'reputation': 1,
    'course': 2,
    'other': 3,
  };

  static const guardianDictionary = {
    'mother': 0,
    'father': 1,
    'other': 2,
  };

  static const binaryDictionary = {
    'yes': 1.0,
    'no': -1.0,
  };

  Student(String data) {
    final fragments = data.replaceAll('"', '').split(';');
    final partialFailures = int.parse(fragments[14]);

    school = fragments[0] == 'GP' ? -1.0 : 1.0;
    sex = fragments[1] == 'F' ? 1.0 : -1.0;
    age = _normalize(int.parse(fragments[2]), 15, 22).normalizedToNegative;
    address = fragments[3] == 'U' ? 1.0 : -1.0;
    familySize = fragments[4] == 'GT3' ? 1.0 : -1.0;
    parentsStatus = fragments[5] == 'A' ? -1.0 : 1.0;
    motherEducation =
        _normalize(int.parse(fragments[6]), 0, 4).normalizedToNegative;
    fatherEducation =
        _normalize(int.parse(fragments[7]), 0, 4).normalizedToNegative;
    motherJob =
        _normalize(jobDictionary[fragments[8]], 0, 4).normalizedToNegative;
    fatherJob =
        _normalize(jobDictionary[fragments[9]], 0, 4).normalizedToNegative;
    reason =
        _normalize(reasonDictionary[fragments[10]], 0, 3).normalizedToNegative;
    guardian = _normalize(guardianDictionary[fragments[11]], 0, 2)
        .normalizedToNegative;
    travelTime =
        _normalize(int.parse(fragments[12]), 0, 4).normalizedToNegative;
    studyTime = _normalize(int.parse(fragments[13]), 0, 4).normalizedToNegative;
    failures = _normalize(partialFailures <= 3 ? partialFailures : 4, 0, 2)
        .normalizedToNegative;
    schoolSupport = binaryDictionary[fragments[15]] ?? -1.0;
    familySupport = binaryDictionary[fragments[16]] ?? -1.0;
    paid = binaryDictionary[fragments[17]] ?? -1.0;
    activities = binaryDictionary[fragments[18]] ?? -1.0;
    nursery = binaryDictionary[fragments[19]] ?? -1.0;
    higher = binaryDictionary[fragments[20]] ?? -1.0;
    internet = binaryDictionary[fragments[21]] ?? -1.0;
    romantic = binaryDictionary[fragments[22]] ?? -1.0;
    familyRelationship =
        _normalize(int.parse(fragments[23]), 0, 5).normalizedToNegative;
    freeTime = _normalize(int.parse(fragments[24]), 0, 5).normalizedToNegative;
    goOut = _normalize(int.parse(fragments[25]), 0, 5).normalizedToNegative;
    workdayAlcohol =
        _normalize(int.parse(fragments[26]), 0, 5).normalizedToNegative;
    weekendAlcohol =
        _normalize(int.parse(fragments[27]), 0, 5).normalizedToNegative;
    health = _normalize(int.parse(fragments[28]), 0, 5).normalizedToNegative;
    absences = _normalize(int.parse(fragments[29]), 0, 93).normalizedToNegative;
    firstGrade =
        _normalize(int.parse(fragments[30]), 0, 20).normalizedToNegative;
    secondGrade =
        _normalize(int.parse(fragments[31]), 0, 20).normalizedToNegative;
    finalGrade =
        _normalize(int.parse(fragments[32]), 0, 20).normalizedToNegative;
  }

  late final double school;
  late final double sex;
  late final double age;
  late final double address;
  late final double familySize;
  late final double parentsStatus;
  late final double motherEducation;
  late final double fatherEducation;
  late final double motherJob;
  late final double fatherJob;
  late final double reason;
  late final double guardian;
  late final double travelTime;
  late final double studyTime;
  late final double failures;
  late final double schoolSupport;
  late final double familySupport;
  late final double paid;
  late final double activities;
  late final double nursery;
  late final double higher;
  late final double internet;
  late final double romantic;
  late final double familyRelationship;
  late final double freeTime;
  late final double goOut;
  late final double workdayAlcohol;
  late final double weekendAlcohol;
  late final double health;
  late final double absences;
  late final double firstGrade;
  late final double secondGrade;
  late final double finalGrade;

  List<double> get inputs => [
        school,
        sex,
        age,
        address,
        familySize,
        parentsStatus,
        motherEducation,
        fatherEducation,
        motherJob,
        fatherJob,
        reason,
        guardian,
        travelTime,
        studyTime,
        failures,
        schoolSupport,
        familySupport,
        paid,
        activities,
        nursery,
        higher,
        internet,
        romantic,
        familyRelationship,
        freeTime,
        goOut,
        workdayAlcohol,
        weekendAlcohol,
        health,
        absences,
      ];

  List<double> get outputs => [
        firstGrade,
        secondGrade,
        finalGrade,
      ];
}
