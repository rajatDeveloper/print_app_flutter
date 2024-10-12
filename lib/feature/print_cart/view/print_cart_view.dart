// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

import 'package:print_app/common/widgets/custom_appbar.dart';
import 'package:print_app/common/widgets/custom_button.dart';
import 'package:print_app/common/widgets/custom_text_field.dart';
import 'package:print_app/common/widgets/loader.dart';
import 'package:print_app/feature/admin/models/test_print.dart';

import 'package:print_app/feature/print_cart/models/print_cart_model.dart';
import 'package:print_app/feature/print_cart/widgets/print_cart_card.dart';
import 'package:print_app/provider/main_provider.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/use_full_function.dart';
import 'package:provider/provider.dart';

class PrintCartView extends StatefulWidget {
  static const routeName = '/print-cart';
  const PrintCartView({super.key});

  @override
  State<PrintCartView> createState() => _PrintCartViewState();
}

class _PrintCartViewState extends State<PrintCartView> {
// Method to calculate total quantity
  int getTotalQuantity(MainProvider provider) {
    return provider.printCartList
            ?.fold(0, (total, e) => total! + (e.quantity ?? 0)) ??
        0;
  }

// Method to calculate total amount
  double getTotalAmount(MainProvider provider, int discount) {
    // Calculate total without discount
    double total = provider.printCartList?.fold(
            0.0,
            (sum, e) =>
                sum! +
                ((e.quantity ?? 0) * (double.parse(e.product!.price!)))) ??
        0.0;

    // Apply discount
    double discountAmount = (total * discount) / 100;

    // Return the amount after applying the discount
    return total - discountAmount;
  }

  // double getTotalAmount(MainProvider provider, int discount) {
  //   return provider.printCartList?.fold(
  //           0.0,
  //           (total, e) =>
  //               total! +
  //               ((e.quantity ?? 0) * (double.parse(e.product!.price!)))) ??
  //       0.0;
  // }

  String mode = "CASH";

  TextEditingController discountController = TextEditingController();
  FocusNode node = FocusNode();

  TestPrint testPrint = TestPrint();
  printData({
    required MainProvider provider,
  }) async {
    testPrint.printMainData(
        invoiceItem: provider.printCartList!,
        mode: mode,
        discount: int.parse(discountController.text));
  }

  @override
  void initState() {
    super.initState();

    // Fetch data after widget is built.
    Future.delayed(Duration.zero, () {
      discountController.text = "0";
      var provider = Provider.of<MainProvider>(context, listen: false);
      provider.getAllPrintCartData(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 5),
              width: getDeviceWidth(context) * 0.35,
              child: Container(
                  width: getDeviceWidth(context) * 0.9,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.grey)),
                  child: DropdownButton<String>(
                    value: mode,
                    underline: Container(),
                    onChanged: (val) {
                      mode = val!;
                      setState(() {});
                    },
                    items: ["CASH", "ONLINE"]
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: getFontSize(
                                        16.5, getDeviceWidth(context))),
                              ),
                            ))
                        .toList(),
                  )),
            ),
            Expanded(
              // width: getDeviceWidth(context) * 0.4,
              child: CustomElevatedBtn(
                  text: "Print",
                  onPressed: () async {
                    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
                    bool isConnected = await bluetooth.isConnected ?? false;
                    var provider =
                        Provider.of<MainProvider>(context, listen: false);
                    if (isConnected == false) {
                      showSnackBar(context, 'Printer not connected');
                      return;
                    } else if (provider.printCartList!.isNotEmpty) {
                      log("working");

                      try {
                        // showLoading(context);
                        await printData(provider: provider);

                        //print recipt and hit api request

                        provider.createHistoryData(
                          context: context,
                          discount: int.parse(discountController.text == ""
                              ? "0"
                              : discountController.text),
                          printProductIds: provider.printCartList!
                              .map((e) => e.id!)
                              .toList(), // Ensure `id` is non-nullable if needed
                          paymentMode: mode,
                        );
                        // hideLoading(context);
                      } catch (e) {
                        // hideLoading(context);
                        showSnackBar(
                            context, "Printing failed: ${e.toString()}");
                      }
                    } else {
                      showSnackBar(context, "Add items to print invoice");
                    }
                  },
                  prefixIcon: Icons.print,
                  bgColor: AppColors.primary,
                  borderColor: Colors.transparent,
                  textColor: AppColors.white,
                  borderRadius: 10),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Print Invoice'),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Consumer<MainProvider>(builder: (context, provider, _) {
                // Handle loading, empty cart, and cart display logic
                if (provider.printCartList == null) {
                  return SizedBox(
                    height: getDeviceHeight(context) * 0.45,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (provider.printCartList!.isEmpty) {
                  return SizedBox(
                    height: getDeviceHeight(context) * 0.45,
                    child: const Center(
                      child: Text(
                        'No items in stack',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: getDeviceWidth(context) * 0.5,
                            child: CustomTextField(
                                borderActiveColor: AppColors.primary,
                                controller: discountController,
                                node: node,
                                isNum: true,
                                hintTextMain: "Enter discount in %"),
                          ),
                          SizedBox(
                            width: getDeviceWidth(context) * 0.01,
                          ),
                          Expanded(
                            // width: getDeviceWidth(context) * 0.4,
                            child: CustomElevatedBtn(
                                text: "Apply",
                                onPressed: () async {
                                  showLoading(context);
                                  //wait 1 sec
                                  await Future.delayed(Duration(seconds: 1));

                                  hideLoading(context);
                                  setState(() {});
                                },
                                prefixIcon: Icons.discount,
                                bgColor: AppColors.primary,
                                borderColor: Colors.transparent,
                                textColor: AppColors.white,
                                borderRadius: 10),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // List of cart items
                      Container(
                        height: getDeviceHeight(context) * 0.48,
                        child: ListView.builder(
                          itemCount: provider.printCartList!.length,
                          itemBuilder: (context, index) {
                            return PrintCartCard(
                              printCartModel: provider.printCartList![index],
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: getDeviceWidth(context),
                        height: 2,
                        color: AppColors.primary,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Quantity: ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                getTotalQuantity(provider).toString(),
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount after discount: ',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "₹${getTotalAmount(provider, int.parse(discountController.text == "" ? "0" : discountController.text)).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
