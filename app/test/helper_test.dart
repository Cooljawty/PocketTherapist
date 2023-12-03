import 'dart:io';

import 'package:app/helper/dates_and_times.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Verify Date Copmarisons", () {
      DateTime before = DateTime.now();
      DateTime beforeTwo = DateTime.now();
      DateTime beforeThree = DateTime.now().add(const Duration(seconds: 5));
      DateTime beforeFour = DateTime(2000, 1, 31);
      DateTime badBeforeFour = DateTime(2000, 1, 32);
      expect(before.isSameDate(beforeTwo, 'Week'), true);
      expect(before.isSameDate(beforeTwo, 'Month'), true);
      expect(before.isSameDate(beforeTwo, 'Year'), true);
      expect(before.isSameDate(beforeThree, 'Test'), false);
      expect(before.isSameDate(beforeFour, 'Year'), false);
      expect(before.isSameDate(beforeFour, 'Month'), false);
      expect(before.isSameDate(beforeFour, 'Day'), false);
      expect(beforeFour.formatDate().day == "31st", true);
  });

}