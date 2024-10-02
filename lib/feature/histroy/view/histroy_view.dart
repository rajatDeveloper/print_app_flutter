import 'package:flutter/material.dart';
import 'package:print_app/common/widgets/custom_appbar.dart';
import 'package:print_app/feature/histroy/widgets/histroy_card.dart';
import 'package:print_app/provider/main_provider.dart';
import 'package:print_app/utils/use_full_function.dart';
import 'package:provider/provider.dart';

class HistroyView extends StatefulWidget {
  static const routeName = '/history';
  const HistroyView({super.key});

  @override
  State<HistroyView> createState() => _HistroyViewState();
}

class _HistroyViewState extends State<HistroyView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      var provider = Provider.of<MainProvider>(context, listen: false);
      provider.getAllHistroyData(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: 'History'),
            Expanded(
              child: Consumer<MainProvider>(
                builder: (context, provider, _) {
                  if (provider.histroyList == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.histroyList!.isEmpty) {
                    return const Center(
                      child: Text('No History Found'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ListView.builder(
                      itemCount: provider.histroyList!.length,
                      itemBuilder: (context, index) {
                        return HistroyCard(model: provider.histroyList![index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
