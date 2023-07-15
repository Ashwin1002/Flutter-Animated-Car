import 'package:flutter/material.dart';

import '../../constanins.dart';

class BatteryStatus extends StatelessWidget {
  const BatteryStatus({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "220 mi",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Colors.white,
                fontSize: 34,
              ),
        ),
        const Text(
          "62%",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        const Spacer(),
        Text(
          "Charging".toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        const Text(
          "18 min remaining",
          style: TextStyle(
            fontSize: 18.5,
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.14),
        const DefaultTextStyle(
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("22 mi/hr"),
                Text("232 v"),
              ],
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
