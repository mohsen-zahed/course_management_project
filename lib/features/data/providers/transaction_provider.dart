import 'package:course_management_project/features/data/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> transactionList = [];
  updateTransactionList(List<TransactionModel> transactionListInput) {
    for (var i = 0; i < transactionListInput.length; i++) {
      if (!transactionList.any((element) => element.id == transactionListInput[i].id)) {
        transactionList.add(transactionListInput[i]);
      }
    }
  }
}
