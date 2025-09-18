import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/main_screen/notifiers/dashboard_notifier.dart';

class CashFlowChart extends ConsumerWidget {
  const CashFlowChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(getCashFlowDetailsAmount);

    return data.when(
      data: (cashFlow) {
        final seriesData = cashFlow.response.series.data;

        final spots = List.generate(seriesData.length, (index) {
          final y = seriesData[index].y?.toDouble() ?? 0.0;
          return FlSpot(index.toDouble(), y);
        });

        final monthLabels = seriesData.map((e) {
          final date = DateTime.tryParse(e.x);
          return date != null ? "${_monthAbbr(date.month)} \n${date.year % 100}" : "";
        }).toList();

        final yValues = seriesData.map((e) => e.y?.toDouble() ?? 0.0).toList();
        final maxY = yValues.reduce((a, b) => a > b ? a : b);
        final minY = yValues.reduce((a, b) => a < b ? a : b);

        final paddedMaxY = maxY; // for visual spacing

        return Container(
          width: double.infinity,
          height: 220,
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, _) {
                      if (value == minY || value == maxY) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            value >= 1000
                                ? "${(value ~/ 1000)}K"
                                : value.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 60,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      return index < monthLabels.length
                          ? Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          monthLabels[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, _, __, index) {
                      return index == spots.length - 1
                          ? FlDotCirclePainter(
                        radius: 4,
                        color: Colors.blue,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      )
                          : FlDotCirclePainter(
                        radius: 0,
                        color: Colors.transparent,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromRGBO(173, 183, 249, 0.3),
                        const Color.fromRGBO(177, 185, 248, 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              minX: 0,
              maxX: seriesData.length.toDouble() - 1,
              minY: minY,
              maxY: paddedMaxY,
            ),
          ),
        );
      },
      error: (err, _) => const SizedBox(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  String _monthAbbr(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }
}
