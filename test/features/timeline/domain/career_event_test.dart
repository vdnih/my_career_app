import 'package:flutter_test/flutter_test.dart';
import 'package:my_career_app/features/timeline/domain/career_event.dart';

void main() {
  group('CareerEvent の機能一覧（仕様）', () {
    test('date文字列 ("yyyy-MM") から正しい DateTime を取得できること', () {
      final event = CareerEvent(
        date: '2023-08',
        title: 'テスト',
        description: 'テスト詳細',
      );

      final dateTime = event.dateTime;

      expect(dateTime.year, 2023);
      expect(dateTime.month, 8);
    });

    test('endDate文字列 ("yyyy-MM") から正しい DateTime を取得できること', () {
      final event = CareerEvent(
        date: '2023-08',
        endDate: '2025-12',
        title: 'テスト',
        description: 'テスト詳細',
      );

      final endDateTime = event.endDateTime;

      expect(endDateTime, isNotNull);
      expect(endDateTime!.year, 2025);
      expect(endDateTime.month, 12);
    });

    test('endDate文字列が未指定の場合は null を返すこと', () {
      final event = CareerEvent(
        date: '2023-08',
        title: 'テスト',
        description: 'テスト詳細',
      );

      final endDateTime = event.endDateTime;

      expect(endDateTime, isNull);
    });

    test('copyWith メソッドで一部のプロパティを変更した新しいインスタンスを正しく生成できること', () {
      final event = CareerEvent(
        date: '2023-08',
        title: '元のタイトル',
        description: '元の詳細',
        isLifeEvent: false,
      );

      final updatedEvent = event.copyWith(title: '変更後のタイトル', isLifeEvent: true);

      expect(updatedEvent.title, '変更後のタイトル');
      expect(updatedEvent.isLifeEvent, true);
      // 未指定のプロパティは引き継がれること
      expect(updatedEvent.date, '2023-08');
      expect(updatedEvent.description, '元の詳細');
    });
  });
}
