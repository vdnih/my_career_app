import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/career_event.dart';

class TimelineEventsNotifier extends Notifier<List<CareerEvent>> {
  @override
  List<CareerEvent> build() {
    // 初期サンプルデータ
    return [
      CareerEvent(
        date: '2019-04',
        title: 'IT企業に入入社',
        description: 'SIerとしてキャリアをスタート',
      ),
      CareerEvent(
        date: '2023-08',
        title: '現職へ転職',
        description: 'DX推進エンジニア・AIエンジニアとして参画',
      ),
      CareerEvent(
        date: '2025-12',
        title: 'ヨーロッパ周遊',
        description: 'サンセバスチャンやロンドンなどを巡る',
        isLifeEvent: true,
      ),
      CareerEvent(
        date: '2026-02',
        title: '結婚式',
        description: 'タイのクラビにて挙式',
        isLifeEvent: true,
      ),
    ];
  }

  void addEvent(CareerEvent event) {
    state = [...state, event];
  }

  void removeEvent(CareerEvent event) {
    state = state.where((e) => e != event).toList();
  }
}

final timelineEventsProvider =
    NotifierProvider<TimelineEventsNotifier, List<CareerEvent>>(() {
      return TimelineEventsNotifier();
    });
