import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/common/navigation.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  static const Color primaryColor = Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor:
      const Color(0xFFF7F7F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        title: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard 🚀',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Here\'s your spending summary ${controller.firstName} 📈',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshExpenses,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  // Date range filter
                  _buildDateFilter(controller),

                  const SizedBox(height: 20),

                  // Total expenses
                  _buildTotalCard(controller),

                  const SizedBox(height: 24),

                  // Daily expenses
                  const Text(
                    'Daily Expenses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildBarChart(controller),

                  const SizedBox(height: 24),

                  // Category pie chart
                  const Text(
                    'Category Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildPieChart(controller),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),

      // Bottom navigation bar
      bottomNavigationBar:
      BottomNavBar(
        currentIndex: 0,

        onItemSelected: (index) {
          if (index == 1) {
            Get.offNamed(
              AppRoutes.expenses,
            );
          } else if (index == 2) {
            Get.offNamed(
              AppRoutes.profile,
            );
          }
        },
      ),
    );
  }

  // Date filter code
  Widget _buildDateFilter(
      DashboardController controller,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(
            'Expense Date Range',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              // Date range button
              Expanded(
                child: InkWell(
                  borderRadius:
                  BorderRadius.circular(12),

                  onTap: () async {
                    final now =
                    DateTime.now();

                    final picked =
                    await showDateRangePicker(
                      context: Get.context!,
                      firstDate:
                      DateTime(2020),
                      lastDate: DateTime(
                        now.year + 1,
                        12,
                        31,
                      ),

                      initialDateRange:
                      controller.startDate
                          .value !=
                          null &&
                          controller.endDate
                              .value !=
                              null
                          ? DateTimeRange(
                        start: controller
                            .startDate
                            .value!,
                        end: controller
                            .endDate
                            .value!,
                      )
                          : null,
                    );

                    if (picked != null) {
                      controller.setDateRange(
                        picked.start,
                        picked.end,
                      );
                    }
                  },

                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      const Color(
                          0xFFF7F7F9),
                      borderRadius:
                      BorderRadius.circular(
                          12),
                    ),

                    child: Row(
                      children: [

                        const Icon(
                          Icons.calendar_month,
                          size: 20,
                          color: primaryColor,
                        ),

                        const SizedBox(
                            width: 8),

                        Expanded(
                          child: Text(
                            _dateRangeText(
                                controller),
                            style:
                            const TextStyle(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Clear filters
              OutlinedButton(
                onPressed:
                controller.clearDateFilter,

                style:
                OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        12),
                  ),
                ),

                child: const Text(
                  'Clear',
                  style:
                  TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Date range txt
  String _dateRangeText(
      DashboardController controller,
      ) {
    if (controller.startDate.value ==
        null ||
        controller.endDate.value ==
            null) {
      return 'All dates';
    }

    return '${_formatDate(controller.startDate.value!)}'
        ' - '
        '${_formatDate(controller.endDate.value!)}';
  }

  // Total expenses code
  Widget _buildTotalCard(
      DashboardController controller,
      ) {
    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(
            'Total Expenses',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Rs. ${controller.totalExpenses.toStringAsFixed(2)}',

            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [

              const Icon(
                Icons.calendar_month,
                color: Colors.white70,
                size: 16,
              ),

              const SizedBox(width: 6),

              Text(
                _dateRangeText(controller),

                style:
                const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bar chart
  Widget _buildBarChart(
      DashboardController controller,
      ) {
    final entries =
        controller.sortedDailyExpenses;

    if (entries.isEmpty) {
      return _emptyCard(
        'No expenses found for this date range.',
      );
    }

    // Find highest expense.
    final highestValue =
    entries
        .map((entry) => entry.value)
        .reduce(
          (a, b) => a > b ? a : b,
    );

    // Give some extra space above the highest bar.
    final double maxY = highestValue <= 0
        ? 100.0
        : (highestValue * 1.2).toDouble();

    // Width based on number of dates
    // This is what makes the chart scrollable.
    final chartWidth =
        entries.length * 65.0;

    return Container(
      height: 310,

      padding:
      const EdgeInsets.fromLTRB(
        8,
        20,
        16,
        12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: SingleChildScrollView(
        scrollDirection:
        Axis.horizontal,

        child: SizedBox(
          width:
          chartWidth < 350
              ? 350
              : chartWidth,

          child: BarChart(
            BarChartData(

              minY: 0,

              maxY: maxY,

              alignment:
              BarChartAlignment.spaceAround,

              borderData:
              FlBorderData(
                show: false,
              ),

              // GRID
              gridData:
              FlGridData(
                show: true,
                drawVerticalLine:
                false,

                horizontalInterval:
                _calculateInterval(
                    maxY),
              ),

              // TOUCH
              barTouchData:
              BarTouchData(
                enabled: true,

                touchTooltipData:
                BarTouchTooltipData(
                  getTooltipItem:
                      (
                      group,
                      groupIndex,
                      rod,
                      rodIndex,
                      ) {
                    final entry =
                    entries[
                    group.x.toInt()];

                    return BarTooltipItem(
                      '${_formatDate(entry.key)}\n'
                          'Rs. ${entry.value.toStringAsFixed(2)}',

                      const TextStyle(
                        color:
                        Colors.white,
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),

              // AXIS TITLES
              titlesData:
              FlTitlesData(

                // TOP
                topTitles:
                const AxisTitles(
                  sideTitles:
                  SideTitles(
                    showTitles: false,
                  ),
                ),

                // RIGHT
                rightTitles:
                const AxisTitles(
                  sideTitles:
                  SideTitles(
                    showTitles: false,
                  ),
                ),

                // Y AXIS
                leftTitles:
                AxisTitles(
                  sideTitles:
                  SideTitles(
                    showTitles: true,
                    reservedSize: 48,

                    interval:
                    _calculateInterval(
                        maxY),

                    getTitlesWidget:
                        (value, meta) {
                      return Text(
                        value.toInt()
                            .toString(),

                        style:
                        const TextStyle(
                          fontSize: 10,
                          color:
                          Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                // X AXIS
                bottomTitles:
                AxisTitles(
                  sideTitles:
                  SideTitles(
                    showTitles: true,
                    reservedSize: 35,

                    getTitlesWidget:
                        (value, meta) {
                      final index =
                      value.toInt();

                      if (index < 0 ||
                          index >=
                              entries.length) {
                        return const SizedBox();
                      }

                      final date =
                          entries[index].key;

                      return Padding(
                        padding:
                        const EdgeInsets
                            .only(
                          top: 8,
                        ),

                        child: Text(
                          '${date.day}/${date.month}',

                          style:
                          const TextStyle(
                            fontSize: 10,
                            color:
                            Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // BARS
              barGroups:
              List.generate(
                entries.length,
                    (index) {
                  final entry =
                  entries[index];

                  return BarChartGroupData(
                    x: index,

                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        width: 24,

                        borderRadius:
                        BorderRadius
                            .circular(
                            5),

                        color:
                        primaryColor,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Y AXIS gaps
  double _calculateInterval(
      double maxY,
      ) {
    if (maxY <= 1000) {
      return 200;
    }

    if (maxY <= 5000) {
      return 1000;
    }

    if (maxY <= 10000) {
      return 2000;
    }

    if (maxY <= 50000) {
      return 10000;
    }

    return maxY / 5;
  }

  // PIE Chart
  Widget _buildPieChart(
      DashboardController controller,
      ) {
    final categories =
        controller.categoryTotals;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          // YEAR + MONTH FILTER
          Row(
            children: [
              // YEAR
              Expanded(
                child:
                DropdownButtonFormField<int?>(
                  value:
                  controller.selectedYear.value,

                  decoration:
                  const InputDecoration(
                    labelText: 'Year',

                    border:
                    OutlineInputBorder(),

                    contentPadding:
                    EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),

                  items: [
                    const DropdownMenuItem<
                        int?>(
                      value: null,
                      child:
                      Text('All Years'),
                    ),

                    ...controller
                        .availableYears
                        .map(
                          (year) {
                        return DropdownMenuItem<
                            int?>(
                          value: year,
                          child: Text(
                            year.toString(),
                          ),
                        );
                      },
                    ),
                  ],

                  onChanged: (value) {
                    controller
                        .setPieYear(value);
                  },
                ),
              ),

              const SizedBox(width: 10),

              // MONTH
              Expanded(
                child:
                DropdownButtonFormField<int?>(
                  value:
                  controller.selectedMonth.value,

                  decoration:
                  const InputDecoration(
                    labelText: 'Month',

                    border:
                    OutlineInputBorder(),

                    contentPadding:
                    EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),

                  items: [
                    const DropdownMenuItem<
                        int?>(
                      value: null,
                      child:
                      Text('All Months'),
                    ),

                    ...List.generate(
                      12,
                          (index) {
                        final month =
                            index + 1;

                        return DropdownMenuItem<
                            int?>(
                          value: month,

                          child: Text(
                            _monthName(
                                month),
                          ),
                        );
                      },
                    ),
                  ],

                  onChanged: (value) {
                    controller
                        .setPieMonth(value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Clear pie chart filter
          Align(
            alignment:
            Alignment.centerRight,

            child: TextButton.icon(
              onPressed:
              controller.clearPieFilter,

              icon: const Icon(
                Icons.clear,
                size: 16,
              ),

              label: const Text(
                'Clear filters',
              ),
            ),
          ),

          const SizedBox(height: 8),

          // PIE
          if (categories.isEmpty)
            const SizedBox(
              height: 220,

              child: Center(
                child: Text(
                  'No expenses found.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 260,

              child: Row(
                children: [

                  // PIE CHART
                  Expanded(
                    flex: 5,

                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius:
                        45,

                        sectionsSpace: 3,

                        sections:
                        _buildPieSections(
                          categories,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                      width: 30),

                  // LEGEND
                  Expanded(
                    flex: 4,

                    child:
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children:
                        _buildLegend(
                          categories,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // PIE chart sections
  List<PieChartSectionData>
  _buildPieSections(
      Map<String, double> categories,
      ) {
    final total =
    categories.values.fold(
      0.0,
          (sum, value) => sum + value,
    );

    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    final entries =
    categories.entries.toList();

    return List.generate(
      entries.length,
          (index) {
        final entry =
        entries[index];

        final percentage =
        total == 0
            ? 0
            : (entry.value /
            total) *
            100;

        return PieChartSectionData(
          value: entry.value,

          title:
          '${percentage.toStringAsFixed(1)}%',

          radius: 65,

          color:
          colors[index %
              colors.length],

          titleStyle:
          const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight:
            FontWeight.bold,
          ),
        );
      },
    );
  }

  // LEGEND section
  List<Widget> _buildLegend(
      Map<String, double> categories,
      ) {
    final total =
    categories.values.fold(
      0.0,
          (sum, value) => sum + value,
    );

    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    final entries =
    categories.entries.toList();

    return List.generate(
      entries.length,
          (index) {
        final entry =
        entries[index];

        final percentage =
        total == 0
            ? 0
            : (entry.value /
            total) *
            100;

        return Padding(
          padding:
          const EdgeInsets.only(
            bottom: 14,
          ),

          child: _CategoryItem(
            color:
            colors[index %
                colors.length],

            title: entry.key,

            percentage:
            '${percentage.toStringAsFixed(1)}%',
          ),
        );
      },
    );
  }

  // EMPTY chart card
  Widget _emptyCard(
      String message,
      ) {
    return Container(
      height: 180,
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.bar_chart,
              size: 40,
              color: Colors.grey,
            ),

            const SizedBox(height: 10),

            Text(
              message,

              style:
              const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Date format
  static String _formatDate(
      DateTime date,
      ) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // Month name
  static String _monthName(
      int month,
      ) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}

// Category item
class _CategoryItem
    extends StatelessWidget {
  final Color color;
  final String title;
  final String percentage;

  const _CategoryItem({
    required this.color,
    required this.title,
    required this.percentage,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Row(
      children: [

        Container(
          width: 12,
          height: 12,

          decoration:
          BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            title,

            overflow:
            TextOverflow.ellipsis,

            style:
            const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),

        Text(
          percentage,

          style:
          const TextStyle(
            fontSize: 13,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ],
    );
  }
}