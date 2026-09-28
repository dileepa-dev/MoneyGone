import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/expense.dart';

class ExpenseController extends GetxController {
  // --------------------------------------------------
  // All expenses
  // --------------------------------------------------

  final RxList<Expense> expenses = <Expense>[].obs;

  // --------------------------------------------------
  // Filters
  // --------------------------------------------------

  final Rx<DateTime?> selectedMonth = Rx<DateTime?>(null);

  final Rx<ExpenseCategory?> selectedCategory =
  Rx<ExpenseCategory?>(null);

  // --------------------------------------------------
  // Filtered expenses
  // --------------------------------------------------

  List<Expense> get filteredExpenses {
    List<Expense> result = List.from(expenses);

    // Filter by month
    if (selectedMonth.value != null) {
      result = result.where((expense) {
        return expense.date.year == selectedMonth.value!.year &&
            expense.date.month == selectedMonth.value!.month;
      }).toList();
    }

    // Filter by category
    if (selectedCategory.value != null) {
      result = result.where((expense) {
        return expense.category == selectedCategory.value;
      }).toList();
    }

    // Newest first
    result.sort((a, b) => b.date.compareTo(a.date));

    return result;
  }

  // --------------------------------------------------
  // Total filtered expenses
  // --------------------------------------------------

  double get filteredTotal {
    return filteredExpenses.fold(
      0,
          (total, expense) => total + expense.amount,
    );
  }

  // --------------------------------------------------
  // Add expense
  // --------------------------------------------------

  void addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? description,
  }) {
    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      category: category,
      date: date,
      description: description,
    );

    expenses.add(expense);
  }

  // --------------------------------------------------
  // Update expense
  // --------------------------------------------------

  void updateExpense({
    required String id,
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? description,
  }) {
    final index = expenses.indexWhere(
          (expense) => expense.id == id,
    );

    if (index == -1) return;

    expenses[index] = expenses[index].copyWith(
      title: title,
      amount: amount,
      category: category,
      date: date,
      description: description,
    );
  }

  // --------------------------------------------------
  // Delete expense
  // --------------------------------------------------

  void deleteExpense(String id) {
    expenses.removeWhere(
          (expense) => expense.id == id,
    );
  }

  // --------------------------------------------------
  // Month filter
  // --------------------------------------------------

  void setMonth(DateTime? month) {
    selectedMonth.value = month;
  }

  // --------------------------------------------------
  // Category filter
  // --------------------------------------------------

  void setCategory(ExpenseCategory? category) {
    selectedCategory.value = category;
  }

  // --------------------------------------------------
  // Clear filters
  // --------------------------------------------------

  void clearFilters() {
    selectedMonth.value = null;
    selectedCategory.value = null;
  }

  // --------------------------------------------------
  // Sample data
  // --------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    expenses.addAll([
      Expense(
        id: '1',
        title: 'Lunch',
        amount: 850,
        category: ExpenseCategory.food,
        date: DateTime(2026, 9, 28),
        description: 'Lunch at restaurant',
      ),
      Expense(
        id: '2',
        title: 'Bus',
        amount: 120,
        category: ExpenseCategory.transport,
        date: DateTime(2026, 9, 27),
      ),
      Expense(
        id: '3',
        title: 'Shopping',
        amount: 4500,
        category: ExpenseCategory.shopping,
        date: DateTime(2026, 9, 25),
      ),
      Expense(
        id: '4',
        title: 'Electricity Bill',
        amount: 3200,
        category: ExpenseCategory.bills,
        date: DateTime(2026, 9, 20),
      ),
    ]);
  }
}