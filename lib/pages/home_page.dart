import 'package:flutter/material.dart';

import '../bloc/bloc_provider.dart';
import '../bloc/game_bloc.dart';
import 'game_page.dart';
import '../model/level.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final gameBloc = BlocProvider.of<GameBloc>(context)!.bloc;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/home_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 300.0),
                child: Container(
                  width: 350,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C6BC5).withOpacity(0.8), // 半透明紫色
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      Level newLevel = await gameBloc.setLevel(1);
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => GamePage(level: newLevel),
                        ),
                      );
                    },
                    child: const Text(
                      'P L A Y',
                      textAlign: TextAlign.center, // 添加文字居中
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'ICELAND',
                        fontSize: 60,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
