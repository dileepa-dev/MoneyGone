import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/expense.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>
  get _expensesCollection =>
      _firestore.collection('expenses');

  String get _currentUserId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    return user.uid;
  }

  // ==================================================
  // CREATE
  // ==================================================

  Future<void> addExpense(Expense expense) async {
    final userId = _currentUserId;

    await _expensesCollection.add({
      ...expense.toFirestore(),
      'userId': userId,
    });
  }

  // ==================================================
  // READ
  // ==================================================

  Stream<List<Expense>> getExpenses() {
    final userId = _currentUserId;

    return _expensesCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final expenses = snapshot.docs
          .map(
            (document) =>
            Expense.fromFirestore(document),
      )
          .toList();

      expenses.sort(
            (a, b) => b.date.compareTo(a.date),
      );

      return expenses;
    });
  }

  // ==================================================
  // UPDATE
  // ==================================================

  Future<void> updateExpense(
      Expense expense,
      ) async {
    final userId = _currentUserId;

    await _expensesCollection
        .doc(expense.id)
        .update({
      'userId': userId,
      'title': expense.title,
      'amount': expense.amount,
      'category': expense.category.name,
      'date': Timestamp.fromDate(expense.date),
      'description': expense.description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================================================
  // DELETE
  // ==================================================

  Future<void> deleteExpense(
      String expenseId,
      ) async {
    await _expensesCollection
        .doc(expenseId)
        .delete();
  }
}