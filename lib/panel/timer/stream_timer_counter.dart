import 'package:flutter/material.dart';

import '../../bloc/bloc_provider.dart';
import '../../bloc/game_bloc.dart';

///
/// StreamTimeCounter
///
/// Displays the remaining time for the game.
/// Listens to the "timeLeft" stream.
///
class StreamTimeCounter extends StatelessWidget {
  const StreamTimeCounter({super.key});

  @override
  Widget build(BuildContext context) {
    GameBloc gameBloc = BlocProvider.of<GameBloc>(context)!.bloc;
    return StreamBuilder<int>(
        initialData: gameBloc.gameController.level.maxSeconds,
        stream: gameBloc.timeLeft,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          final int seconds = snapshot.data ?? 0;
          final String minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
          final String secondsStr = (seconds % 60).toString().padLeft(2, '0');
          final Color color = seconds <= 10 ? Colors.red : Colors.white;
          return Text(
            '$minutesStr:$secondsStr',
            style: TextStyle(
              color: color,
              fontFamily: 'ICELAND',
              fontSize: 100.0, // 增大字体
              fontWeight: FontWeight.bold, // 加粗
            ),
          );
        });
  }
}
