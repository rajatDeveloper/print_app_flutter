import 'package:flutter/material.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/use_full_function.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final bool isBackButton;
  final bool isCartNotRequired;
  const CustomAppBar({
    super.key,
    this.isCartNotRequired = false,
    required this.title,
    this.isBackButton = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      alignment: Alignment.center,
      width: getDeviceWidth(context),
      decoration: BoxDecoration(
          color: widget.isBackButton ? AppColors.white : AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: widget.isBackButton
                  ? AppColors.grey
                  : AppColors.primary.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 6), // changes position of shadow
            ),
          ],
          //bottom right and left radiis
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              widget.isBackButton
                  ? Navigator.of(context).pop()
                  : Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              widget.isBackButton ? Icons.arrow_back_ios_new : Icons.menu,
              color: widget.isBackButton ? AppColors.black : AppColors.white,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: getDeviceWidth(context) * 0.5,
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.isBackButton ? AppColors.black : AppColors.white,
                fontSize: getFontSize(16, getDeviceWidth(context)),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          widget.isCartNotRequired
              ? const SizedBox(
                  width: 30,
                )
              : IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.admin_panel_settings_sharp,
                    size: 30,
                    color:
                        widget.isBackButton ? AppColors.black : AppColors.white,
                  ),
                ),
        ],
      ),
    );
  }
}
