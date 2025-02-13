import 'package:course_management_project/features/data/blocs/student_details_bloc/student_details_bloc.dart';
import 'package:course_management_project/features/data/providers/transaction_provider.dart';
import 'package:course_management_project/features/screens/initial_screens/login_screen/login_screen.dart';
import 'package:course_management_project/features/screens/main_screens/transactions_details_screen/widgets/transaction_info_card.dart';
import 'package:course_management_project/packages/dio_package/dio_package.dart';
import 'package:course_management_project/packages/dio_package/status_codes.dart';
import 'package:course_management_project/packages/flushbar_package/flushbar_package.dart';
import 'package:course_management_project/widgets/custom_empty_widget.dart';
import 'package:course_management_project/widgets/custom_error_widget.dart';
import 'package:course_management_project/widgets/custom_loading_indicator.dart';
import 'package:course_management_project/widgets/scaffold_background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TransactionsDetailsScreen extends StatefulWidget {
  static const String id = '/transactions_screen';
  const TransactionsDetailsScreen({super.key, required this.studentId, required this.type, required this.studentName});

  final int studentId;
  final String type;
  final String studentName;

  @override
  State<TransactionsDetailsScreen> createState() => _TransactionsDetailsScreenState();
}

class _TransactionsDetailsScreenState extends State<TransactionsDetailsScreen> {
  late ScrollController _scrollController;
  late VoidCallback _scrollListener;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollListener = () {
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (StudentDetailsBloc.transactionHasMore) {
          context.read<StudentDetailsBloc>().add(
                TransactionDetailsRequested(
                  studentId: widget.studentId,
                  type: 'Transaction',
                  page: StudentDetailsBloc.transactionPage + 1,
                  hideLoading: true,
                ),
              );
        }
      }
    };
    _scrollController.addListener(_scrollListener);
    context.read<StudentDetailsBloc>().add(
          TransactionDetailsRequested(studentId: widget.studentId, type: widget.type, page: 1),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentDetailsBloc, StudentDetailsState>(
      listener: (context, state) {
        if (state is TransactionFailure) {
          if (state.errorMessage.contains(StatusCodes.unAthurizedCode)) {
            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
            FlushbarPackage.showFlushbar(context, 'لطفا دوباره وارد حساب خود شوید!');
          } else if (state.errorMessage.contains(StatusCodes.noInternetConnectionCode)) {
            FlushbarPackage.showFlushbar(context, 'اتصال به اینترنت خود را چک کنید!');
          } else if (state.errorMessage.contains(StatusCodes.noServerFoundCode)) {
            FlushbarPackage.showFlushbar(context, 'خطایی از طرف سرور رخ داده است، دوباره امتحان کنید!');
          } else if (state.errorMessage.contains(StatusCodes.badStateCode)) {
            FlushbarPackage.showFlushbar(context, 'خطایی رخ داده است، دوباره امتحان کنید!');
          } else if (state.errorMessage.contains(StatusCodes.unknownCode)) {
            FlushbarPackage.showFlushbar(context, 'خطایی نامشخص رخ داده است، بعدا امتحان کنید!');
          } else {
            FlushbarPackage.showErrorFlushbar(context, state.errorMessage);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('مبادلات پولی ${widget.studentName}')),
          body: ScaffoldBackgroundImage(
            child: SafeArea(
              child: PopScope(
                canPop: true,
                onPopInvoked: (didPop) {
                  if (state is StudentDetailsLoading && !cancelToken.isCancelled) {
                    cancelToken.cancel();
                  }
                  context.read<TransactionProvider>().transactionList.clear();
                },
                child: state is StudentDetailsLoading
                    ? const CustomLoadingIndicator()
                    : state is TransactionSuccess
                        ? Consumer<TransactionProvider>(
                            builder: (context, transactionProvider, child) {
                              return transactionProvider.transactionList.isEmpty
                                  ? const CustomEmptyWidget()
                                  : RefreshIndicator(
                                      onRefresh: () async {
                                        context.read<StudentDetailsBloc>().add(
                                              TransactionDetailsRequested(
                                                studentId: widget.studentId,
                                                type: widget.type,
                                                page: 1,
                                              ),
                                            );
                                      },
                                      child: ListView.separated(
                                        controller: _scrollController,
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        itemCount: transactionProvider.transactionList.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index < transactionProvider.transactionList.length) {
                                            final transactionModel = transactionProvider.transactionList[index];
                                            return TransactionInfoCard(
                                              index: index,
                                              transactionModel: transactionModel,
                                              studentName: transactionModel.studentName,
                                              lastName: transactionModel.lastName,
                                            );
                                          } else {
                                            if (StudentDetailsBloc.transactionHasMore &&
                                                index == transactionProvider.transactionList.length &&
                                                transactionProvider.transactionList.length >= 30) {
                                              return const CustomLoadingIndicator();
                                            }
                                            return SizedBox.fromSize(size: Size.zero);
                                          }
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(height: 5);
                                        },
                                      ),
                                    );
                            },
                          )
                        : CustomErrorWidget(
                            onTap: () {
                              context.read<StudentDetailsBloc>().add(
                                    TransactionDetailsRequested(
                                      studentId: widget.studentId,
                                      type: widget.type,
                                      page: 1,
                                    ),
                                  );
                            },
                          ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// class TransactionsDataSource extends DataGridSource {
//   static List<TransactionModel> students = [];
//   List<TransactionModel>? studentsInfo;
//   List<DataGridRow> dataGridRows = [];

//   TransactionsDataSource(this.studentsInfo) {
//     students = studentsInfo ?? [];
//     buildDataGridRows();
//   }

//   @override
//   List<DataGridRow> get rows => dataGridRows;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//       cells: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           alignment: Alignment.centerRight,
//           child: Text(
//             row.getCells()[0].value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(8),
//           alignment: Alignment.centerRight,
//           child: Text(
//             row.getCells()[1].value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(8),
//           alignment: Alignment.centerRight,
//           child: Text(
//             row.getCells()[2].value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(8),
//           alignment: Alignment.centerRight,
//           child: Text(
//             row.getCells()[3].value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(8),
//           alignment: Alignment.centerRight,
//           child: Text(
//             row.getCells()[4].value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(8),
//           alignment: Alignment.centerRight,
//           child: Text(
//             row.getCells()[5].value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(8),
//           alignment: Alignment.centerRight,
//           child: Text(
//             row.getCells()[6].value.toString(),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   void buildDataGridRows() {
//     int number = 1;
//     dataGridRows = students
//         .map<DataGridRow>(
//           (student) => DataGridRow(
//             cells: [
//               DataGridCell(columnName: 'num', value: '${number + 1}'),
//               DataGridCell(columnName: 'name', value: student.studentName),
//               DataGridCell(columnName: 'accountName', value: student.accountName),
//               DataGridCell(columnName: 'num', value: student.amount),
//               DataGridCell(columnName: 'num', value: student.type),
//               DataGridCell(columnName: 'num', value: student.date),
//               DataGridCell(columnName: 'num', value: student.description),
//             ],
//           ),
//         )
//         .toList();
//   }
// }

// List<GridColumn> columns = [
//   GridColumn(
//     columnName: 'num',
//     label: Container(
//       padding: const EdgeInsets.all(8),
//       alignment: Alignment.centerRight,
//       child: const Text(
//         'شماره',
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//   ),
//   GridColumn(
//     columnName: 'name',
//     label: Container(
//       padding: const EdgeInsets.all(8),
//       alignment: Alignment.centerRight,
//       child: const Text(
//         'نام شاگرد',
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//   ),
//   GridColumn(
//     columnName: 'accountName',
//     label: Container(
//       padding: const EdgeInsets.all(8),
//       alignment: Alignment.centerRight,
//       child: const Text(
//         'نام حساب',
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//   ),
//   GridColumn(
//     columnName: 'amount',
//     label: Container(
//       padding: const EdgeInsets.all(8),
//       alignment: Alignment.centerRight,
//       child: const Text(
//         'مقدار',
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//   ),
//   GridColumn(
//     columnName: 'type',
//     label: Container(
//       padding: const EdgeInsets.all(8),
//       alignment: Alignment.centerRight,
//       child: const Text(
//         'نوعیت',
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//   ),
//   GridColumn(
//     columnName: 'date',
//     label: Container(
//       padding: const EdgeInsets.all(8),
//       alignment: Alignment.centerRight,
//       child: const Text(
//         'تاریخ',
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//   ),
//   GridColumn(
//     columnName: 'description',
//     label: Container(
//       padding: const EdgeInsets.all(8),
//       alignment: Alignment.centerRight,
//       child: const Text(
//         'توضیحات',
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//   ),
// ];
