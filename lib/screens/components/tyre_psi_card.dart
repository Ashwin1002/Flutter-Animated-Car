import 'package:flutter/material.dart';

import '../../constanins.dart';
import '../../models/TyrePsi.dart';

class TyrePsiCard extends StatelessWidget {
  const TyrePsiCard(
      {super.key, required this.isBottomTwoTyre, required this.tyrePsi});

  final bool isBottomTwoTyre;
  final TyrePsi tyrePsi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color:
            tyrePsi.isLowPressure ? redColor.withOpacity(0.1) : Colors.white10,
        border: Border.all(
          color: tyrePsi.isLowPressure ? redColor : primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: isBottomTwoTyre
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                lowPressureText(context),
                const Spacer(),
                psiText(context, text: tyrePsi.psi.toString()),
                const SizedBox(height: defaultPadding),
                Text(
                  "${tyrePsi.temp}\u2103",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                psiText(context, text: tyrePsi.psi.toString()),
                const SizedBox(height: defaultPadding),
                Text(
                  "${tyrePsi.temp}\u2103",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Spacer(),
                lowPressureText(context)
              ],
            ),
    );
  }

  Widget lowPressureText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Low".toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        Text(
          "Pressure".toUpperCase(),
          style: const TextStyle(fontSize: 20),
        )
      ],
    );
  }

  RichText psiText(BuildContext context, {required String text}) {
    return RichText(
      text: TextSpan(
          text: text,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
          children: const <TextSpan>[
            TextSpan(
              text: "psi",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            )
          ]),
    );
  }
}
