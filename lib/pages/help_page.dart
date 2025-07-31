import 'package:flutter/material.dart';
import '../bloc/bloc_provider.dart';
import '../bloc/game_bloc.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 设置Scaffold背景为透明
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
          // 使用SafeArea确保内容不被状态栏遮挡
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Swipe up to blow out the candle, \nand get 10 extra seconds!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'ICELAND',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // 这里可以继续添加交互内容
            ],
          ),
        ),
      ),
    );
  }
}
