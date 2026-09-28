import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:moneygone/app/routes/app_routes.dart';

import '../../widgets/common/navigation.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // Sample daily expenses
  final List<double> dailyExpenses = const [
    1200,
    2500,
    1800,
    3200,
    2100,
    4500,
    2800,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Dileepa 👋',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Here\'s your spending summary',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFEDE9FE),
              child: Icon(
                Icons.person,
                color: Color(0xFF8162FF),
              ),
            ),
          ),
        ],
      ),

      // =========================
      // BODY
      // =========================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================
              // MONTH
              // =========================
              const Text(
                'September 2026',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // TOTAL EXPENSE CARD
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8162FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Expenses',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Rs. 45,250.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'This month',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // DAILY EXPENSES TITLE
              // =========================
              const Text(
                'Daily Expenses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // BAR CHART
              // =========================
              Container(
                height: 280,
                padding: const EdgeInsets.fromLTRB(12, 20, 20, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BarChart(
                  BarChartData(
                    maxY: 5000,

                    borderData: FlBorderData(
                      show: false,
                    ),

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000,
                    ),

                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          interval: 1000,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ];

                            if (value.toInt() >= days.length) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                days[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    barGroups: List.generate(
                      dailyExpenses.length,
                      (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: dailyExpenses[index],
                              width: 18,
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFF8162FF),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // CATEGORY TITLE
              // =========================
              const Text(
                'Category Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // PIE CHART
              // =========================
              Container(
                height: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [

                    // PIE CHART
                    Expanded(
                      flex: 5,
                      child: PieChart(
                        PieChartData(
                          centerSpaceRadius: 45,
                          sectionsSpace: 3,

                          sections: [
                            PieChartSectionData(
                              value: 40,
                              title: '40%',
                              radius: 65,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            PieChartSectionData(
                              value: 25,
                              title: '25%',
                              radius: 65,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            PieChartSectionData(
                              value: 20,
                              title: '20%',
                              radius: 65,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            PieChartSectionData(
                              value: 15,
                              title: '15%',
                              radius: 65,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // CATEGORY LEGEND
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _CategoryItem(
                            color: Colors.blue,
                            title: 'Food',
                            percentage: '40%',
                          ),
                          SizedBox(height: 16),

                          _CategoryItem(
                            color: Colors.orange,
                            title: 'Transport',
                            percentage: '25%',
                          ),
                          SizedBox(height: 16),

                          _CategoryItem(
                            color: Colors.green,
                            title: 'Bills',
                            percentage: '20%',
                          ),
                          SizedBox(height: 16),

                          _CategoryItem(
                            color: Colors.purple,
                            title: 'Other',
                            percentage: '15%',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================
      bottomNavigationBar: BottomNavBar(
         currentIndex: 0, 
         onItemSelected: (index) {
           if (index == 1) { 
            Get.toNamed(
              AppRoutes.expenses
              ); 
            } else if (index == 2) { 
              Get.toNamed(
                AppRoutes.profile
                ); 
              } 
           },
      ),
    );
  }
}

// ======================================================
// CATEGORY ITEM
// ======================================================

class _CategoryItem extends StatelessWidget {
  final Color color;
  final String title;
  final String percentage;

  const _CategoryItem({
    required this.color,
    required this.title,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),

        Text(
          percentage,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}