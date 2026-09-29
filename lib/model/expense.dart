import 'package:cloud_firestore/cloud_firestore.dart';

enum ExpenseCategory {
  food,
  transport,
  shopping,
  bills,
  entertainment,
  health,
  education,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.bills:
        return 'Bills';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.health:
        return 'Health';
      case ExpenseCategory.education:
        return 'Education';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  String get value {
    return name;
  }

  static ExpenseCategory fromString(String value) {
    return ExpenseCategory.values.firstWhere(
          (category) => category.name == value,
      orElse: () => ExpenseCategory.other,
    );
  }
}

class Expense {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? description;

  Expense({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  // Convert Firestore document -> Expense
  factory Expense.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data();

    if (data == null) {
      throw Exception('Expense data is empty.');
    }

    final timestamp = data['date'] as Timestamp?;

    return Expense(
      id: document.id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      category: ExpenseCategoryExtension.fromString(
        data['category'] as String? ?? 'other',
      ),
      date: timestamp?.toDate() ?? DateTime.now(),
      description: data['description'] as String?,
    );
  }

  // Convert Expense -> Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'amount': amount,
      'category': category.name,
      'date': Timestamp.fromDate(date),
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Expense copyWith({
    String? id,
    String? userId,
    String? title,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? description,
  }) {
    return Expense(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}