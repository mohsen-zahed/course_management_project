import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.maxLines = 10});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: widget.text.length > (widget.maxLines * 20) && !_isExpanded
                    ? widget.text.substring(0, widget.maxLines * 10)
                    : widget.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (widget.text.length > (widget.maxLines * 20))
                TextSpan(
                  text: _isExpanded ? '...نمایش کمتر' : ' ...نمایش بیشتر',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kBlueColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        _isExpanded = !_isExpanded; //
                      });
                    },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
