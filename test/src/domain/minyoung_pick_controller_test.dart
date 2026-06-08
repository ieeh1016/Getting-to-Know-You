import 'package:flutter_test/flutter_test.dart';
import 'package:minyoung_pick/src/domain/minyoung_pick_controller.dart';

void main() {
  group('MinyoungPickController', () {
    test('starts with the first idea and no selections', () {
      final controller = MinyoungPickController();

      expect(controller.activeIdea.title, '디저트 먼저 먹기');
      expect(controller.state.selectedDateId, isNull);
      expect(controller.state.selectedPreferences, isEmpty);
      expect(controller.state.usedCouponIds, isEmpty);
    });

    test('stores one selected date option', () {
      final controller = MinyoungPickController();

      controller.selectDate('hanriver_walk');

      expect(controller.state.selectedDateId, 'hanriver_walk');
    });

    test('cycles ideas in a deterministic order', () {
      final controller = MinyoungPickController();

      controller.showNextIdea();
      expect(controller.activeIdea.title, '가볍게 산책');

      controller.showNextIdea();
      expect(controller.activeIdea.title, '조용한 영화');

      controller.showNextIdea();
      expect(controller.activeIdea.title, '디저트 먼저 먹기');
    });

    test('stores preferences and toggles coupon usage', () {
      final controller = MinyoungPickController();

      controller.selectPreference('food', '파스타');
      controller.toggleCoupon('coffee');

      expect(controller.state.selectedPreferences['food'], '파스타');
      expect(controller.state.usedCouponIds, contains('coffee'));

      controller.toggleCoupon('coffee');

      expect(controller.state.usedCouponIds, isNot(contains('coffee')));
    });
  });
}
