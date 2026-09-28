import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/expense_controller.dart';
import '../../model/expense.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddEditExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState
    extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ExpenseController expenseController = Get.find<ExpenseController>();

  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  DateTime _selectedDate = DateTime.now();

  bool get isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();

    final expense = widget.expense;

    if (expense != null) {
      _titleController.text = expense.title;
      _amountController.text =
          expense.amount.toString();
      _descriptionController.text =
          expense.description ?? '';

      _selectedCategory = expense.category;
      _selectedDate = expense.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEditing
              ? 'Edit Expense'
              : 'Add Expense',
        ),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Lunch',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter a title *';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: '0.00',
                prefixText: 'Rs. ',
                prefixIcon:
                Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter an amount *';
                }

                final amount =
                double.tryParse(value);

                if (amount == null ||
                    amount <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon:
                Icon(Icons.category),
              ),
              items: ExpenseCategory.values
                  .map(
                    (category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category.displayName,
                    ),
                  );
                },
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // Date
            InkWell(
              onTap: _selectDate,
              borderRadius:
              BorderRadius.circular(12),
              child: InputDecorator(
                decoration:
                const InputDecoration(
                  labelText: 'Date *',
                  prefixIcon:
                  Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${_selectedDate.day}/'
                      '${_selectedDate.month}/'
                      '${_selectedDate.year}',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller:
              _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Note / Description',
                hintText:
                'Optional description',
                prefixIcon:
                Icon(Icons.notes),
              ),
            ),

            const SizedBox(height: 30),

            // Save button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _saveExpense,
                child: Text(
                  isEditing
                      ? 'Update Expense'
                      : 'Add Expense',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text.trim());
    final description = _descriptionController.text.trim();

    if (isEditing) {
      expenseController.updateExpense(
        id: widget.expense!.id,
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        description:
        description.isEmpty ? null : description,
      );

      Get.back();

      Get.snackbar(
        'Expense updated',
        'Your expense was updated successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      expenseController.addExpense(
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        description:
        description.isEmpty ? null : description,
      );

      Get.back();

      Get.snackbar(
        'Expense added',
        'Your expense was added successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
}