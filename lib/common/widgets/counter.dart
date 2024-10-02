import 'package:flutter/material.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/use_full_function.dart';

class CounterBtn extends StatefulWidget {
  CounterBtn({
    Key? key,
    required this.onTapData,
    this.count,
    required this.initialValue,
  }) : super(key: key);
  final Function(int str) onTapData;
  int? count;
  int initialValue;

  @override
  State<CounterBtn> createState() => _CounterBtnState();
}

class _CounterBtnState extends State<CounterBtn> {
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (counter > 1) {
                if (widget.count == null) {
                  counter = counter - 1;
                  widget.onTapData(counter);
                } else {
                  counter = counter - widget.count!;
                  widget.onTapData(counter);
                }
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.primary)),
            child: const Icon(
              Icons.remove,
              size: 32,
              color: AppColors.primary,
            ),
          ),
        ),
        Text(
          counter.toString(),
          style: TextStyle(
              fontSize: getFontSize(16, getDeviceWidth(context)),
              fontWeight: FontWeight.w700),
        ),
        InkWell(
          onTap: () {
            setState(() {
              if (widget.count == null) {
                counter = counter + 1;
                widget.onTapData(counter);
              } else {
                counter = counter + widget.count!;
                widget.onTapData(counter);
              }
            });
          },
          child: Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: AppColors.primary,
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(5)),
            child: const Icon(
              Icons.add,
              size: 33,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
