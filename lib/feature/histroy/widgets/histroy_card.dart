import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:print_app/feature/histroy/models/histroy_model.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/use_full_function.dart';

class HistroyCard extends StatefulWidget {
  final HistroyModel model;
  const HistroyCard({super.key, required this.model});

  @override
  State<HistroyCard> createState() => _HistroyCardState();
}

class _HistroyCardState extends State<HistroyCard> {
  bool showDetails = false;
  int getTotalQuantity() {
    int totalQuantity = 0;
    for (var item in widget.model.print_cart!) {
      totalQuantity += item.quantity!;
    }
    return totalQuantity;
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in widget.model.print_cart!) {
      totalPrice += item.quantity! * double.parse(item.product!.price!);
    }
    return totalPrice;
  }

  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Define the desired format
    DateFormat formatter = DateFormat('d MMM yyyy h:mm a');

    // Format the DateTime object to the desired string format
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Id: ${widget.model.id}"),
              Text(formatDate(widget.model.date!)),
              Text("${widget.model.payment_mode}"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Quantity: ${getTotalQuantity()}"),
              Text("₹${getTotalPrice()}")
            ],
          ),
          showDetails
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      height: 1,
                      color: AppColors.primary,
                      width: getDeviceWidth(context),
                    ),
                    for (var item in widget.model.print_cart!)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${item.product!.name}"),
                              Text(
                                  "₹${item.product!.price} x ${item.quantity}"),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            height: 1,
                            color: AppColors.primary,
                            width: getDeviceWidth(context),
                          ),
                        ],
                      ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          showDetails = false;
                          setState(() {});
                        },
                        child: Text("Hide Details"),
                      ),
                    )
                  ],
                )
              : Center(
                  child: TextButton(
                    onPressed: () {
                      showDetails = true;
                      setState(() {});
                    },
                    child: Text("View Details"),
                  ),
                )
        ],
      ),
    );
  }
}
