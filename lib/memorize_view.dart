import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorize_mvvm_bloc/banner/emoji_banner.dart';
import 'package:memorize_mvvm_bloc/button/restartGame_button.dart';
import 'package:memorize_mvvm_bloc/vm_memorize.dart';
import 'button/newGame_button.dart';

class MemorizeView extends StatefulWidget {
  const MemorizeView({super.key});

  @override
  State<MemorizeView> createState() {
    return _MemorizeViewState();
  }
}

class _MemorizeViewState extends State<MemorizeView> {
  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: Column(
        children: [
          BlocBuilder<MemorizeCubit, MemorizeState>(
            builder: (context, state) {
              return EmojiBanner(gradientColor: state.bundleCardModel.gradientColor);
            }
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: NewGameButton(newGame: () {
                      context.read<MemorizeCubit>().onNewGameTap();
                    }
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<MemorizeCubit, MemorizeState>(
                        builder: (context, state) {
                          return Text(
                            state.bundleCardModel.emoji,
                            style: const TextStyle(color: Colors.white)
                          );
                        }
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('S C O R E  |  ',
                          style: TextStyle(color: Colors.white)
                      ),
                      BlocBuilder<MemorizeCubit, MemorizeState>(
                        builder: (context, state) {
                          return Text(
                            state.score.toString(),
                            style: const TextStyle(color: Colors.red)
                          );
                        },
                      ),
                    ]
                  )
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: BlocBuilder<MemorizeCubit, MemorizeState>(
                builder: (context, state) {
                  return GridView.builder(
                    itemCount: state.bundleCardModel.cardObject.length,
                    itemBuilder: (ctx, index) {
                      if (context.read<MemorizeCubit>().countCorrect.contains(index)) {
                        return Container();
                      }
                      return _onCardView(index);
                    },
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 8,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: RestartGameButton(restart: () {
         context.read<MemorizeCubit>().onRestartGameTap();
      }),
    );
  }

  Widget _onCardView(int index) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.read<MemorizeCubit>().onTapp(index, context);
        },
        child: BlocBuilder<MemorizeCubit, MemorizeState>(
          builder: (context, state) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: state.bundleCardModel.cardObject[index].isSelected
                    ? state.bundleCardModel.gradientColor
                    : [
                        const Color(0xFF212121),
                        const Color(0xFF212121)
                      ]
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: state.bundleCardModel.color.withOpacity(0.7),
                    spreadRadius: 1,
                    blurRadius: 15
                  ),
                ],
              ),
              margin: const EdgeInsets.all(5),
              child: state.bundleCardModel.cardObject[index].isSelected
                ? Text(
                    state.bundleCardModel.cardObject[index].emoji,
                    style: const TextStyle(
                      fontSize: 20, color: Colors.black),
                  )
                : const Text(
                    '',
                    style:
                      TextStyle(fontSize: 20, color: Colors.white),
                  ),
            );
          },
        ),
      )
    );
  }
}