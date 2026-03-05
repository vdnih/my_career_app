import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_career_app/features/timeline/presentation/widgets/add_event_dialog.dart';

void main() {
  group('AddEventDialog の機能一覧（仕様）', () {
    testWidgets('タイトル、開始・終了年月、仕事/プライベートの選択が正しくUI入力できること', (tester) async {
      bool isSubmitted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showAddEventDialog(
                      context,
                      initialDate: DateTime(2023, 8),
                      onSubmit: (title, startDateStr, endDateStr, isLifeEvent) {
                        isSubmitted = true;
                        expect(title, 'テストイベント');
                        expect(
                          startDateStr,
                          startsWith('2023-'),
                        ); // 日付のフォーマットチェック
                        expect(isLifeEvent, false); // 初期値が仕事であることを確認
                      },
                    );
                  },
                  child: const Text('ダイアログ開く'),
                );
              },
            ),
          ),
        ),
      );

      // ボタンをタップしてダイアログを開く
      await tester.tap(find.text('ダイアログ開く'));
      await tester.pumpAndSettle();

      // UI 요소의 렌더링 확인
      expect(find.text('イベントを追加'), findsOneWidget);

      // イベント名入力
      await tester.enterText(find.byType(TextField), 'テストイベント');

      // 追加ボタンタップ
      await tester.tap(find.text('追加'));
      await tester.pumpAndSettle();

      expect(isSubmitted, true);
    });

    testWidgets('イベント名が空の場合は「追加」ボタンを押しても処理が実行されない(ダイアログが閉じない)こと', (
      tester,
    ) async {
      bool isSubmitted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showAddEventDialog(
                      context,
                      onSubmit: (title, startDateStr, endDateStr, isLifeEvent) {
                        isSubmitted = true;
                      },
                    );
                  },
                  child: const Text('ダイアログ開く'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('ダイアログ開く'));
      await tester.pumpAndSettle();

      // TextFieldは空のまま、「追加」ボタンをタップ
      await tester.tap(find.text('追加'));
      await tester.pump();

      // Submit関数は呼ばれていない
      expect(isSubmitted, false);
      // ダイアログは依然として開いている
      expect(find.text('イベントを追加'), findsOneWidget);
    });

    testWidgets('期間指定トグルをONにすると終了年月が入力可能になること', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showAddEventDialog(
                      context,
                      onSubmit:
                          (title, startDateStr, endDateStr, isLifeEvent) {},
                    );
                  },
                  child: const Text('ダイアログを開く'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('ダイアログを開く'));
      await tester.pumpAndSettle();

      // 当初は終了年月が表示されていない
      expect(find.text('終了年月'), findsNothing);

      // 期間指定トグルをタップ
      await tester.tap(find.text('期間を指定する'));
      await tester.pumpAndSettle();

      // 終了年月が表示される
      expect(find.text('終了年月'), findsOneWidget);
    });
  });
}
