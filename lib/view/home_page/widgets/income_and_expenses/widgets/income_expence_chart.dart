import 'package:payzo_books/data/models/income_and_expences/income_and_expences.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/main_screen/notifiers/dashboard_notifier.dart';

class IncomeExpenceChart extends ConsumerWidget {
  const IncomeExpenceChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(fetchIncomeAndExpenses);

    return data.when(
      data: (data) {
        List<String> monthLabels = [
          "Apr\n24", "May\n24", "Jun\n24", "Jul\n24",
          "Aug\n24", "Sep\n24", "Oct\n24", "Nov\n24",
          "Dec\n24", "Jan\n25", "Feb\n25", "Mar\n25"
        ];

        final incomeRaw = data.response?.incomeSeries?.data ?? [];
        final expenseRaw = data.response?.expenseSeries?.data ?? [];

        final List<ChartData> incomeData = List.generate(
          12,
              (i) => i < incomeRaw.length
              ? incomeRaw[i]
              : ChartData(x: null, y: 0),
        );

        final List<ChartData> expenseData = List.generate(
          12,
              (i) => i < expenseRaw.length
              ? expenseRaw[i]
              : ChartData(x: null, y: 0),
        );

        List<FlSpot> incomeSpots = [];
        List<FlSpot> expenseSpots = [];

        double minY = double.infinity;
        double maxY = double.negativeInfinity;

        for (int i = 0; i < 12; i++) {
          final incomeY = (incomeData[i].y ?? 0).toDouble();
          final expenseY = (expenseData[i].y ?? 0).toDouble();

          incomeSpots.add(FlSpot(i.toDouble(), incomeY));
          expenseSpots.add(FlSpot(i.toDouble(), expenseY));

          minY = [minY, incomeY, expenseY].reduce((a, b) => a < b ? a : b);
          maxY = [maxY, incomeY, expenseY].reduce((a, b) => a > b ? a : b);
        }

        minY = (minY > 0) ? 0 : minY - 1000;
        maxY = maxY + 1000;

        return Container(
          width: double.infinity,
          height: 220,
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 11,
              minY: minY,
              maxY: maxY,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, _) {
                      final middleY = ((minY + maxY) / 2).roundToDouble();
                      bool isMin = (value - minY).abs() < 0.01;
                      bool isMax = (value - maxY).abs() < 0.01;
                      bool isMid = (value - middleY).abs() < 0.01;

                      if (isMin || isMid || isMax) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '${(value ~/ 1000)}K',
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
                    reservedSize: 32,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index >= 0 && index < monthLabels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            monthLabels[index],
                            textAlign: TextAlign.center,
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
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: incomeSpots,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  color: Colors.green,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withValues(
                          alpha: 0.4
                        ),
                        Colors.green.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: expenseSpots,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  color: Colors.red,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent.withValues(alpha: 0.4),
                        Colors.red.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (err, _) => const SizedBox(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
