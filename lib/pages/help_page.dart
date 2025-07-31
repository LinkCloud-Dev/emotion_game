import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool _candleIsLit = true;
  bool _hasEarnedReward = false;
  String _displayText =
      'Swipe up to blow out the candle, \nand get 10 extra seconds!';
  void _onSwipeUp() {
    if (_candleIsLit && !_hasEarnedReward) {
      setState(() {
        _candleIsLit = false;
        _hasEarnedReward = true;
        _displayText = "You've earned 10 seconds!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_hasEarnedReward ? 10 : 0);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent, // 设置Scaffold背景为透明
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.of(context).pop(_hasEarnedReward ? 10 : 0),
          ),
          backgroundColor: Colors.transparent, // AppBar也设为透明
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white), // 图标改为白色
        ),
        extendBodyBehindAppBar: true, // 让body延伸到AppBar后面
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/help_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    _displayText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'ICELAND',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      // 检测向上滑动手势 (dy < 0 表示向上)
                      if (details.delta.dy < -5) {
                        _onSwipeUp();
                      }
                    },
                    child: Center(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          _candleIsLit
                              ? 'assets/images/candle/candle_lit.jpg'
                              : 'assets/images/candle/candle_out.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
