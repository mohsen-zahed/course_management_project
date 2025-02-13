import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key, this.message, this.textColor});
  final String? message;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(color: textColor),
          const SizedBox(height: 10),
          Text(
            message ?? 'در حال بارگیری اطلاعات...',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}
