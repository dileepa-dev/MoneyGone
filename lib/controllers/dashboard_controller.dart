import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoading = true.obs;

  // All expenses belonging to the logged-in user
  final RxList<Map<String, dynamic>> allExpenses = <Map<String, dynamic>>[].obs;

  // DATE RANGE FILTER
  // Initially set to the current month.
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();

  // PIE CHART FILTER
  // Initially set to current year + current month.
  final RxnInt selectedYear = RxnInt();
  final RxnInt selectedMonth = RxnInt();

  // Initialize and refresh
  Future<void> refreshDashboard() async {
    // Clear date range filters
    startDate.value = null;
    endDate.value = null;

    // Clear pie chart filters
    selectedYear.value = null;
    selectedMonth.value = null;

    // Load latest expenses from Firestore
    await loadExpenses();
  }

  @override
  void onInit() {
    super.onInit();

    refreshDashboard();
  }

  // Initial filters
  void _setInitialFilters() {
    final now = DateTime.now();

    // Current month's first day.
    startDate.value = DateTime(
      now.year,
      now.month,
      1,
    );

    // Current month's last day.
    endDate.value = DateTime(
      now.year,
      now.month + 1,
      0,
    );

    // Pie chart initially shows current month.
    selectedYear.value = now.year;
    selectedMonth.value = now.month;
  }

  String get firstName {
    final name = FirebaseAuth.instance.currentUser?.displayName;

    if (name == null || name.trim().isEmpty) {
      return 'there';
    }

    return name.trim().split(' ').first;
  }

  // Load all expenses
  Future<void> loadExpenses() async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;

      // No logged-in user.
      if (user == null) {
        allExpenses.clear();
        return;
      }

      final snapshot = await _firestore
          .collection('expenses')
          .where(
        'userId',
        isEqualTo: user.uid,
      )
          .get();

      final List<Map<String, dynamic>> expenses =
      snapshot.docs.map((document) {
        return {
          'id': document.id,
          ...document.data(),
        };
      }).toList();

      allExpenses.assignAll(expenses);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to load expenses.',
        snackPosition: SnackPosition.BOTTOM,
      );
      // print('Dashboard expense error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh expenses
  Future<void> refreshExpenses() async {
    await refreshDashboard();
  }

  // Get the expenses date
  DateTime? getExpenseDate(
      Map<String, dynamic> expense,
      ) {
    final value = expense['date'];

    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  // Get expenses cost
  double getExpenseAmount(
      Map<String, dynamic> expense,
      ) {
    final value = expense['amount'];

    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  // Date range filter expenses
  List<Map<String, dynamic>> get filteredExpenses {
    // If filter is cleared, return everything.
    if (startDate.value == null ||
        endDate.value == null) {
      return allExpenses.toList();
    }

    final start = DateTime(
      startDate.value!.year,
      startDate.value!.month,
      startDate.value!.day,
    );

    final end = DateTime(
      endDate.value!.year,
      endDate.value!.month,
      endDate.value!.day,
      23,
      59,
      59,
    );

    return allExpenses.where((expense) {
      final date = getExpenseDate(expense);

      if (date == null) {
        return false;
      }

      return !date.isBefore(start) &&
          !date.isAfter(end);
    }).toList();
  }

  // Get the total expense
  double get totalExpenses {
    return filteredExpenses.fold(
      0,
          (total, expense) {
        return total + getExpenseAmount(expense);
      },
    );
  }

  // Daily expenses data
  // Multiple expenses on the same day are combined.
  Map<DateTime, double> get dailyExpenses {
    final Map<DateTime, double> result = {};

    for (final expense in filteredExpenses) {
      final date = getExpenseDate(expense);

      if (date == null) {
        continue;
      }

      final day = DateTime(
        date.year,
        date.month,
        date.day,
      );

      result[day] =
          (result[day] ?? 0) +
              getExpenseAmount(expense);
    }

    return result;
  }

  // Sorted daily expenses
  List<MapEntry<DateTime, double>>
  get sortedDailyExpenses {
    final entries =
    dailyExpenses.entries.toList();

    entries.sort(
          (a, b) => a.key.compareTo(b.key),
    );

    return entries;
  }

  // PIE CHART EXPENSES
  // Independent from the date range filter.
  List<Map<String, dynamic>> get pieExpenses {
    return allExpenses.where((expense) {
      final date = getExpenseDate(expense);

      if (date == null) {
        return false;
      }

      // Filter by year if selected.
      if (selectedYear.value != null &&
          date.year != selectedYear.value) {
        return false;
      }

      // Filter by month if selected.
      if (selectedMonth.value != null &&
          date.month != selectedMonth.value) {
        return false;
      }

      return true;
    }).toList();
  }

  // Calculate category totals
  Map<String, double> get categoryTotals {
    final Map<String, double> result = {};

    for (final expense in pieExpenses) {
      final category =
      (expense['category'] ?? 'Other').toString();

      result[category] =
          (result[category] ?? 0) +
              getExpenseAmount(expense);
    }

    return result;
  }

  // Years available
  List<int> get availableYears {
    final Set<int> years = {};

    for (final expense in allExpenses) {
      final date = getExpenseDate(expense);

      if (date != null) {
        years.add(date.year);
      }
    }

    final result = years.toList();

    result.sort(
          (a, b) => b.compareTo(a),
    );

    return result;
  }

  // Select the date range
  void setDateRange(
      DateTime start,
      DateTime end,
      ) {
    startDate.value = start;
    endDate.value = end;
  }

  // Clear the date range
  // Shows all expenses.
  void clearDateFilter() {
    startDate.value = null;
    endDate.value = null;
  }

  // SET PIE YEAR
  void setPieYear(int? year) {
    selectedYear.value = year;
  }

  // SET PIE MONTH
  void setPieMonth(int? month) {
    selectedMonth.value = month;
  }
  // CLEAR PIE FILTER
  // Shows all years + all months.
  void clearPieFilter() {
    selectedYear.value = null;
    selectedMonth.value = null;
  }
}