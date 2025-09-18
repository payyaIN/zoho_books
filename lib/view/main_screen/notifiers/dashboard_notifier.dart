import 'package:payzo_books/data/models/cash_flow_model.dart';
import 'package:payzo_books/data/models/income_and_expences/income_and_expences.dart';
import 'package:payzo_books/data/repository/dashboard/cash_flow_repository.dart';
import 'package:payzo_books/data/repository/dashboard/income_expence_repo.dart';
import 'package:payzo_books/data/repository/get_total_recievables_repository.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/data/models/get_total_recievables.dart';
import '../../../data/models/get_total_payments_model.dart';
import '../../../data/repository/dashboard/get_total_payables_repository.dart';

final getTotalRecievablesAmount = FutureProvider<GetTotalRecievables>((ref) async {
  final repository = ref.watch(getTotalRecieveablesProvider);
  return repository.fetchData();
});
final getTotalPayableAmount = FutureProvider<GetTotalPayables>((ref) async {
  final repository = ref.watch(getTotalPayablesAmount);
  return repository.fetchData();
});
final getCashFlowDetailsAmount = FutureProvider<CashFlowModel>((ref) async {
  final repository = ref.watch(getCashFlowProvider);
  return repository.fetchData();
});
final fetchIncomeAndExpenses = FutureProvider<IncomeAndExpenses>((ref) async {
  final repository = ref.watch(getIncomeAndExpenseProvider);
  return repository.fetchData();
});
