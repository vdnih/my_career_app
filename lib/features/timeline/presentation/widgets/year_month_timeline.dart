import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../user_profile/user_profile.dart';
import '../../domain/career_event.dart';

class YearMonthTimeline extends ConsumerWidget {
  final List<CareerEvent> events;

  const YearMonthTimeline({super.key, required this.events});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (events.isEmpty) return const Center(child: Text('No events found'));

    final profile = ref.watch(userProfileNotifierProvider);

    // データの期間を計算
    final sortedEvents = List<CareerEvent>.from(events)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final firstDate = sortedEvents.first.dateTime;
    DateTime lastDate = sortedEvents.last.dateTime;

    // 終了日も考慮して最後の月を計算
    for (var event in events) {
      if (event.hasDuration && event.endDateTime!.isAfter(lastDate)) {
        lastDate = event.endDateTime!;
      }
    }

    // 表示期間を少し広げる (前後3ヶ月)
    final startDate = DateTime(firstDate.year, firstDate.month - 3);
    final endDate = DateTime(lastDate.year, lastDate.month + 6);

    final totalMonths =
        ((endDate.year - startDate.year) * 12) +
        (endDate.month - startDate.month);

    const double monthWidth = 60.0;
    const double axisHeight = 60.0;
    const double rowHeight = 160.0;

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左側の固定ラベル
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: SizedBox(
              width: 36,
              height: axisHeight + rowHeight * 2,
              child: Column(
                children: [
                  SizedBox(height: axisHeight),
                  // 仕事ラベル
                  Container(
                    height: rowHeight,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                        right: BorderSide(
                          color: Colors.blueGrey.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: const RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        '仕事',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                  // プライベートラベル
                  Container(
                    height: rowHeight,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                        top: BorderSide(
                          color: Colors.blueGrey.withOpacity(0.3),
                        ),
                        right: BorderSide(
                          color: Colors.blueGrey.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: const RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'プライベート',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 右側のスクロール可能なタイムライン
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 40, bottom: 40, right: 40),
              child: SizedBox(
                width: totalMonths * monthWidth + 100,
                height: axisHeight + rowHeight * 2,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 仕事とプライベートの境界線
                    Positioned(
                      top: axisHeight + rowHeight,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: Colors.blueGrey.withOpacity(0.3),
                      ),
                    ),

                    // メインの横線 (タイムラインのベース)
                    Positioned(
                      top: axisHeight,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: Colors.blueGrey.withOpacity(0.3),
                      ),
                    ),

                    // 月ごとの目盛りとラベル
                    ...List.generate(totalMonths + 1, (index) {
                      final currentDate = DateTime(
                        startDate.year,
                        startDate.month + index,
                      );
                      final xPos = 20.0 + (index * monthWidth);
                      final isJan = currentDate.month == 1;
                      final ageAtDate = profile.calculateAgeAt(currentDate);

                      return Positioned(
                        left: xPos - 20,
                        top: axisHeight - (isJan ? 55 : 25),
                        child: SizedBox(
                          width: 40,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isJan) ...[
                                if (ageAtDate != null)
                                  Text(
                                    '$ageAtDate歳',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey.withOpacity(0.8),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                Text(
                                  '${currentDate.year}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                              ] else ...[
                                Text(
                                  '${currentDate.month}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blueGrey.withOpacity(0.6),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                              ],
                              Container(
                                width: 2,
                                height: isJan ? 12 : 6,
                                color: isJan
                                    ? Colors.blueGrey
                                    : Colors.blueGrey.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // 期間を持つイベントの矢印を描画
                    ...events.where((e) => e.hasDuration).map((event) {
                      final eventDate = event.dateTime;
                      final endDate = event.endDateTime!;
                      final startOffset =
                          ((eventDate.year - startDate.year) * 12) +
                          (eventDate.month - startDate.month);
                      final endOffset =
                          ((endDate.year - startDate.year) * 12) +
                          (endDate.month - startDate.month);

                      final startXPos = 20.0 + (startOffset * monthWidth);
                      final endXPos = 20.0 + (endOffset * monthWidth);

                      final rowTop = event.isLifeEvent
                          ? axisHeight + rowHeight
                          : axisHeight;
                      final baseTop =
                          rowTop + 24.0 + 50.0 + 6.0 + 12.0; // center of icon

                      final color = event.isLifeEvent
                          ? Colors.orange
                          : Colors.blue;

                      return Positioned(
                        left:
                            startXPos +
                            12, // start from right side of the icon roughly
                        top: baseTop - 1, // center line
                        width: endXPos - startXPos - 12,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 2,
                                color: color.withOpacity(0.6),
                              ),
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: color.withOpacity(0.6),
                              size: 16,
                            ),
                          ],
                        ),
                      );
                    }),

                    // イベントの配置
                    ...events.map((event) {
                      final eventDate = event.dateTime;
                      final monthOffset =
                          ((eventDate.year - startDate.year) * 12) +
                          (eventDate.month - startDate.month);
                      final xPos = 20.0 + (monthOffset * monthWidth);

                      final rowTop = event.isLifeEvent
                          ? axisHeight + rowHeight
                          : axisHeight;
                      final topPadding = 24.0;

                      return Positioned(
                        left: xPos - 60,
                        top: rowTop + topPadding,
                        child: GestureDetector(
                          onTap: () => _showEventDetails(context, event),
                          child: SizedBox(
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: event.isLifeEvent
                                        ? Colors.orange.shade50
                                        : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: event.isLifeEvent
                                          ? Colors.orange
                                          : Colors.blue,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    event.title,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: event.isLifeEvent
                                          ? Colors.orange.shade800
                                          : Colors.blue.shade800,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Icon(
                                  event.isLifeEvent
                                      ? Icons.favorite
                                      : Icons.work,
                                  color: event.isLifeEvent
                                      ? Colors.orange
                                      : Colors.blue,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, CareerEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              event.isLifeEvent ? Icons.favorite : Icons.work,
              color: event.isLifeEvent ? Colors.orange : Colors.blue,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(event.title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.hasDuration
                  ? '${event.date} 〜 ${event.endDate}'
                  : event.date,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(event.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('了解'),
          ),
        ],
      ),
    );
  }
}
