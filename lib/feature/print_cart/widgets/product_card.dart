import 'package:flutter/material.dart';
import 'package:print_app/common/widgets/counter.dart';
import 'package:print_app/common/widgets/loader.dart';
import 'package:print_app/feature/print_cart/models/product_model.dart';
import 'package:print_app/provider/main_provider.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/use_full_function.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel model;
  const ProductCard({super.key, required this.model});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int counter = 1;
  void showCustomDialog(BuildContext context, MainProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.model.name!),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹${widget.model.price.toString()}",
                style: TextStyle(color: AppColors.primary),
              ),
              const Spacer(),
              CounterBtn(
                  onTapData: (val) {
                    counter = val;
                  },
                  initialValue: counter)
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Action when "Cancel" button is pressed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  showLoading(context);
                  await provider.addToPrintCartService(
                      context: context,
                      productId: widget.model.id!,
                      quantity: counter);
                  hideLoading(context);
                  // showSnackBar(context, "Item added to invoice");
                } catch (e) {
                  hideLoading(context);
                  showSnackBar(context, e.toString());
                }

                // Call a method from provider
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Add to invoice',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, provider, _) {
      return InkWell(
        onTap: () {
          showCustomDialog(context, provider);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.model.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: AppColors.primary),
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      child: Text(
                        widget.model.category!,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.white),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "₹${widget.model.price.toString()}",
                    style: TextStyle(color: AppColors.primary),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
