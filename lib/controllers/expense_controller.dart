import 'dart:async';

import 'package:get/get.dart';

import '../model/expense.dart';
import '../repositories/expense_repository.dart';

class ExpenseController extends GetxController {
  final ExpenseRepository _repository =
  ExpenseRepository();

  // ==================================================
  // State
  // ==================================================

  final RxList<Expense> expenses = <Expense>[].obs;

  final RxBool isLoading = false.obs;

  final RxBool isSaving = false.obs;

  final RxBool isDeleting = false.obs;

  final RxString errorMessage = ''.obs;

  StreamSubscription<List<Expense>>?
  _expenseSubscription;

  // ==================================================
  // Filters
  // ==================================================

  final Rx<DateTime?> selectedMonth =
  Rx<DateTime?>(null);

  final Rx<ExpenseCategory?> selectedCategory =
  Rx<ExpenseCategory?>(null);

  // ==================================================
  // Lifecycle
  // ==================================================

  @override
  void onInit() {
    super.onInit();

    loadExpenses();
  }

  @override
  void onClose() {
    _expenseSubscription?.cancel();
    super.onClose();
  }

  // ==================================================
  // READ
  // ==================================================

  void loadExpenses() {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      _expenseSubscription =
          _repository.getExpenses().listen(
                (data) {
              expenses.assignAll(data);
              isLoading.value = false;
            },
            onError: (error) {
              isLoading.value = false;
              errorMessage.value =
              'Unable to load expenses.';
            },
          );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value =
      'Unable to load expenses.';
    }
  }

  // ==================================================
  // FILTERED EXPENSES
  // ==================================================

  List<Expense> get filteredExpenses {
    List<Expense> result =
    List<Expense>.from(expenses);

    // Date filter
    if (selectedMonth.value != null) {
      final selectedDate = selectedMonth.value!;

      result = result.where((expense) {
        return expense.date.year == selectedDate.year &&
            expense.date.month == selectedDate.month &&
            expense.date.day == selectedDate.day;
      }).toList();
    }

    // Category filter
    if (selectedCategory.value != null) {
      result = result.where((expense) {
        return expense.category ==
            selectedCategory.value;
      }).toList();
    }

    // Newest first
    result.sort(
          (a, b) => b.date.compareTo(a.date),
    );

    return result;
  }

  // ==================================================
  // TOTAL
  // ==================================================

  double get filteredTotal {
    return filteredExpenses.fold(
      0.0,
          (total, expense) =>
      total + expense.amount,
    );
  }

  // ==================================================
  // ADD
  // ==================================================

  Future<bool> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? description,
  }) async {
    try {
      isSaving.value = true;

      final expense = Expense(
        id: '',
        userId: '',
        title: title,
        amount: amount,
        category: category,
        date: date,
        description: description,
      );

      await _repository.addExpense(expense);

      return true;
    } catch (e) {
      errorMessage.value =
      'Unable to add expense.';
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ==================================================
  // UPDATE
  // ==================================================

  Future<bool> updateExpense({
    required String id,
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? description,
  }) async {
    try {
      isSaving.value = true;

      final existingExpense =
      expenses.firstWhere(
            (expense) => expense.id == id,
      );

      final updatedExpense =
      existingExpense.copyWith(
        title: title,
        amount: amount,
        category: category,
        date: date,
        description: description,
      );

      await _repository.updateExpense(
        updatedExpense,
      );

      return true;
    } catch (e) {
      errorMessage.value =
      'Unable to update expense.';
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  // ==================================================
  // DELETE
  // ==================================================

  Future<bool> deleteExpense(
      String id,
      ) async {
    try {
      isDeleting.value = true;

      await _repository.deleteExpense(id);

      return true;
    } catch (e) {
      errorMessage.value =
      'Unable to delete expense.';
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  // ==================================================
  // MONTH FILTER
  // ==================================================

  void setMonth(DateTime? month) {
    selectedMonth.value = month;
  }

  // ==================================================
  // CATEGORY FILTER
  // ==================================================

  void setCategory(
      ExpenseCategory? category,
      ) {
    selectedCategory.value = category;
  }

  // ==================================================
  // CLEAR FILTERS
  // ==================================================

  void clearFilters() {
    selectedMonth.value = null;
    selectedCategory.value = null;
  }

  Future<void> refreshExpenses() async {
    await _expenseSubscription?.cancel();

    loadExpenses();

    await Future.delayed(
      const Duration(milliseconds: 500),
    );
  }
}