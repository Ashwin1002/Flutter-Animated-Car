import 'package:animated_car/constanins.dart';
import 'package:animated_car/models/TyrePsi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/home_controller.dart';

import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/tesla_bottom_navigationbar.dart';
import 'components/tmp_details.dart';
import 'components/tyre_psi_card.dart';
import 'components/tyres.dart';

// Next Episode show you the battery tab animation
// Thank you!

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// use SingleTickerProviderStateMixin for one animation controller otherwise change to TickerProviderStateMixin
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationCoolGlow;

  late AnimationController _tyreAnimationController;

  late List<Animation<double>> _tyreAnimations;
  //we want each tyre one by one
  late Animation<double> _animationTyre1Psi;
  late Animation<double> _animationTyre2Psi;
  late Animation<double> _animationTyre3Psi;
  late Animation<double> _animationTyre4Psi;

  void setupBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      // So this animtion start at 0 and end on half
      // this means, after 300 milliseconds [total duration is 600 ms].
      //here animation end on 0.5
      curve: const Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      //After a delay we start the animation
      //after 60 milliseconds delay animation starts
      // so it start at 360 ms and end on 600 ms
      curve: const Interval(0.6, 1),
    );
  }

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // first we wait battery animation to complete so we start the animation from 0.4
    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.2, 0.4),
    );

    _animationTempShowInfo = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.45, 0.65),
    );

    _animationCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.7, 1),
    );
  }

  void setupTyreAnimation() {
    _tyreAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // we will delay the aniatiom for 400 ms
    //because with in this time the car animate from right side
    //1200 * 0.34 = 408
    _animationTyre1Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: const Interval(0.34, 0.5),
    );
    _animationTyre2Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: const Interval(0.5, 0.66),
    );
    _animationTyre3Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: const Interval(0.66, 0.82),
    );
    _animationTyre4Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: const Interval(0.82, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    setupTyreAnimation();
    _tyreAnimations = [
      _animationTyre1Psi,
      _animationTyre2Psi,
      _animationTyre3Psi,
      _animationTyre4Psi,
    ];
    super.initState();
  }

  @override
  void dispose() {
    // always dispose the controller after use
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    _tyreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _batteryAnimationController,
          _tempAnimationController,
          _tyreAnimationController
        ]),
        builder: (context, _) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavigationBar(
              onTap: (index) {
                //once user click on battery tab, then we want battery
                // animation to start
                if (index == 1) {
                  _batteryAnimationController.forward();
                  // we can use _controller.selectedBottomTab == 1
                  // because after check it change the tab
                } else if (_controller.selectedBottomTab == 1 && index != 1) {
                  _batteryAnimationController.reverse(from: 0.7);
                }

                if (index == 2) {
                  _tempAnimationController.forward();
                } else if (_controller.selectedBottomTab == 2 && index != 2) {
                  _tempAnimationController.reverse(from: 0.4);
                }

                if (index == 3) {
                  _tyreAnimationController.forward();
                } else if (_controller.selectedBottomTab == 3 && index != 3) {
                  _tyreAnimationController.reverse(from: 0.4);
                }

                _controller.showTyreController(index);
                _controller.tyreStatusController(index);
                _controller.onBottomNavigationTabChanged(index);
              },
              selectedTab: _controller.selectedBottomTab,
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: constrains.maxHeight,
                        width: constrains.maxWidth,
                      ),
                      Positioned(
                        left:
                            constrains.maxWidth / 2 * _animationCarShift.value,
                        height: constrains.maxHeight,
                        width: constrains.maxWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: constrains.maxHeight * 0.1),
                          child: SvgPicture.asset(
                            "assets/icons/Car.svg",
                            width: double.infinity,
                          ),
                        ),
                      ),
                      // Door Locks
                      AnimatedPositioned(
                        duration: defaultDuration,
                        right: _controller.selectedBottomTab == 0
                            ? constrains.maxWidth * 0.05
                            : constrains.maxWidth / 2,
                        child: AnimatedOpacity(
                          duration: defaultDuration,
                          opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                          child: DoorLock(
                            isLock: _controller.isRightDoorLock,
                            press: _controller.updateRightDoorLock,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: defaultDuration,
                        left: _controller.selectedBottomTab == 0
                            ? constrains.maxWidth * 0.05
                            : constrains.maxWidth / 2,
                        child: AnimatedOpacity(
                          duration: defaultDuration,
                          opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                          child: DoorLock(
                            isLock: _controller.isLeftDoorLock,
                            press: _controller.updateLeftDoorLock,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: defaultDuration,
                        top: _controller.selectedBottomTab == 0
                            ? constrains.maxWidth * 0.13
                            : constrains.maxWidth / 2,
                        child: AnimatedOpacity(
                          duration: defaultDuration,
                          opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                          child: DoorLock(
                            isLock: _controller.isBonnetLock,
                            press: _controller.updateBonnetDoorLock,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: defaultDuration,
                        bottom: _controller.selectedBottomTab == 0
                            ? constrains.maxWidth * 0.17
                            : constrains.maxWidth / 2,
                        child: AnimatedOpacity(
                          duration: defaultDuration,
                          opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                          child: DoorLock(
                            isLock: _controller.isTrunkLock,
                            press: _controller.updateTrunkDoorLock,
                          ),
                        ),
                      ),

                      //battery
                      Opacity(
                        opacity: _animationBattery.value,
                        child: SvgPicture.asset(
                          "assets/icons/Battery.svg",
                          width: constrains.maxWidth * 0.40,
                        ),
                      ),

                      Positioned(
                        top: 50 * (1 - _animationBatteryStatus.value),
                        height: constrains.maxHeight,
                        width: constrains.maxWidth,
                        child: Opacity(
                          opacity: _animationBatteryStatus.value,
                          child: BatteryStatus(constraints: constrains),
                        ),
                      ),

                      //temperature
                      Positioned(
                        height: constrains.maxHeight,
                        width: constrains.maxWidth,
                        top: 60 * (1 - _animationTempShowInfo.value),
                        child: Opacity(
                          opacity: _animationTempShowInfo.value,
                          child: TempDetails(controller: _controller),
                        ),
                      ),
                      //temp glow
                      Positioned(
                        right: -180 * (1 - _animationCoolGlow.value),
                        child: AnimatedSwitcher(
                          duration: defaultDuration,
                          child: _controller.isCoolSelected
                              ? Image.asset(
                                  "assets/images/Cool_glow_2.png",
                                  width: 180,
                                  key: UniqueKey(),
                                )
                              : Image.asset(
                                  "assets/images/Hot_glow_4.png",
                                  width: 180,
                                  key: UniqueKey(),
                                ),
                        ),
                      ),

                      // Tyre
                      if (_controller.showTyres) ...tyres(constrains),
                      if (_controller.isShowTyreStatus)
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: GridView.builder(
                            itemCount: demoPsiList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: defaultPadding,
                              crossAxisSpacing: defaultPadding,
                              childAspectRatio:
                                  constrains.maxWidth / constrains.maxHeight,
                            ),
                            itemBuilder: (context, index) => ScaleTransition(
                              scale: _tyreAnimations[index],
                              child: TyrePsiCard(
                                isBottomTwoTyre: index > 1,
                                tyrePsi: demoPsiList[index],
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}
