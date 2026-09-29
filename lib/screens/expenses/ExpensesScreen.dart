import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../model/expense.dart';
import '../../widgets/common/navigation.dart';
import 'AddEditExpenseScreen.dart';
import '../../app/routes/app_routes.dart';

class ExpensesScreen extends StatelessWidget {
  ExpensesScreen({super.key});

  final ExpenseController controller = Get.put(ExpenseController());
  final dashboardController = Get.put(DashboardController());

  final Color green = const Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Expenses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(
            () {
          final expenses = controller.filteredExpenses;

          // Loading
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              expenses.isEmpty) {
            return _buildErrorState();
          }

          return Column(
            children: [
              // Total expenses
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  8,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(16),
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
                    const SizedBox(height: 6),
                    Text(
                      'Rs. ${controller.filteredTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Filters
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMonthFilter(context),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _buildCategoryFilter(),
                        ),

                        const SizedBox(width: 8),

                        SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              controller.clearFilters();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: const Icon(
                              Icons.clear,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Swipe left to delete • Tap an expense to edit',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Expense history
              Expanded(
                child: expenses.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                  onRefresh: controller.refreshExpenses,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];

                      return _buildExpenseCard(
                        context,
                        expense,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Add Expense
      floatingActionButton: FloatingActionButton(
        backgroundColor: green,
        onPressed: () {
          Get.to(
                () => const AddEditExpenseScreen(),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onItemSelected: (index) {
          if (index == 0) {
            Get.offNamed(
              AppRoutes.dashBoard,
            );
            dashboardController.refreshDashboard();
          } else if (index == 2) {
            Get.offNamed(
              AppRoutes.profile,
            );
          }
        },
      ),
    );
  }

  // Month filter
  Widget _buildMonthFilter(
      BuildContext context,
      ) {
    return OutlinedButton.icon(
      onPressed: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate:
          controller.selectedMonth.value ??
              DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );

        if (selected != null) {
          controller.setMonth(selected);
        }
      },
      icon: const Icon(Icons.calendar_month),
      label: Obx(
            () => Text(
          controller.selectedMonth.value == null
              ? 'Month'
              : DateFormat('dd MMM yyyy').format(
            controller.selectedMonth.value!,
          ),
        ),
      ),
    );
  }

  // Category filter
  Widget _buildCategoryFilter() {
    return Obx(
          () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<ExpenseCategory?>(
              initialValue: controller.selectedCategory.value,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<ExpenseCategory?>(
                  value: null,
                  child: Text('All'),
                ),
                ...ExpenseCategory.values.map(
                      (category) {
                    return DropdownMenuItem<ExpenseCategory?>(
                      value: category,
                      child: Text(
                        category.displayName,
                      ),
                    );
                  },
                ),
              ],
              onChanged: controller.setCategory,
            ),
          ],
        );
      },
    );
  }


  // Expense card
  Widget _buildExpenseCard(
      BuildContext context,
      Expense expense,
      ) {
    return Dismissible(
      key: Key(expense.id),

      direction: DismissDirection.endToStart,

      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      // Delete confirmation
      confirmDismiss: (_) async {
        return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Delete Expense'),
            content: const Text(
              'Are you sure you want to delete this expense?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Get.back(result: true);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },

      // Delete
      onDismissed: (_) async {
        final success =
        await controller.deleteExpense(
          expense.id,
        );

        if (success) {
          Get.snackbar(
            'Expense Deleted',
            '${expense.title} was removed.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Unable to delete expense.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },

      // Expense card
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          // Tap expense -> Edit
          onTap: () {
            Get.to(
                  () => AddEditExpenseScreen(
                expense: expense,
              ),
            );
          },

          leading: CircleAvatar(
            backgroundColor:
            green.withValues(alpha: 0.1),
            child: Icon(
              _getCategoryIcon(
                expense.category,
              ),
              color: green,
            ),
          ),

          title: Text(
            expense.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Text(
            '${expense.category.displayName} • '
                '${DateFormat('dd MMM yyyy').format(expense.date)}',
          ),

          trailing: Text(
            'Rs. ${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  // Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'No expenses found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try changing your filters or add a new expense.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Error State
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load expenses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.loadExpenses,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }


  // Category icons
  IconData _getCategoryIcon(
      ExpenseCategory category,
      ) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;

      case ExpenseCategory.transport:
        return Icons.directions_bus;

      case ExpenseCategory.shopping:
        return Icons.shopping_bag;

      case ExpenseCategory.bills:
        return Icons.receipt;

      case ExpenseCategory.entertainment:
        return Icons.movie;

      case ExpenseCategory.health:
        return Icons.health_and_safety;

      case ExpenseCategory.education:
        return Icons.school;

      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }
}