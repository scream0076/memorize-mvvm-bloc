import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorize_mvvm_bloc/data/bundleCard_data.dart';
import 'package:memorize_mvvm_bloc/models/bundleCard_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

randomBundleCard() {
  int cardBundleRandom = Random().nextInt(bundleCard.length);
  BundleCardModel selectedBundleCard = bundleCard[cardBundleRandom];
  return selectedBundleCard;
}

class MemorizeCubit extends Cubit<MemorizeState> {
  MemorizeCubit() : super(MemorizeState(bundleCardModel: randomBundleCard(), score: 0));

  int score = 0;
  bool isFlipping = false;
  int matchCorrect = 0;
  List<int> countInCorrect = [];
  List<int> countCorrect = [];
  List<IsCardSelected> isCardSelected = [];

  void onTapp(int index, BuildContext context) {
    if(!isFlipping && !state.bundleCardModel.cardObject[index].isSelected) {
      state.bundleCardModel.cardObject[index].isSelected = true;
      emit(MemorizeState(bundleCardModel: state.bundleCardModel, score: state.score));
      isCardSelected.add(
        IsCardSelected(
          cardIndex: index,
          cardEmoji: state.bundleCardModel.cardObject[index].emoji
        )
      );
    }

    if (isCardSelected.length >= 2) {
      isFlipping = true;

      if (isCardSelected[0].cardEmoji == isCardSelected[1].cardEmoji) {
        Future.delayed(const Duration(seconds: 1), () {
          emit(MemorizeState(bundleCardModel: state.bundleCardModel, score: score += 2));
          matchCorrect++;
          isFlipping = false;
          // ignore: avoid_function_literals_in_foreach_calls
          isCardSelected.forEach((selectedCard) {
            countCorrect.add(selectedCard.cardIndex);
            emit(MemorizeState(bundleCardModel: state.bundleCardModel, score: state.score));
          });
          
          isCardSelected = [];

          if (matchCorrect == state.bundleCardModel.cardObject.length ~/ 2) {
            _showGameOverDialog(context);
          }
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          // ignore: avoid_function_literals_in_foreach_calls
          isCardSelected.forEach((selectedCard) {
            state.bundleCardModel.cardObject[selectedCard.cardIndex].isSelected = false;
            emit(MemorizeState(bundleCardModel: state.bundleCardModel, score: state.score));

            if (countInCorrect.contains(selectedCard.cardIndex)) {
              if (score != 0) {
                emit(MemorizeState(bundleCardModel: state.bundleCardModel, score: score -= 1));
              }
            }

            countInCorrect.add(selectedCard.cardIndex);                
          });

          isFlipping = false;
          isCardSelected = [];
        });
      }
    }
  }

  void onNewGameTap() {
    state.bundleCardModel.cardObject.shuffle();
    isFlipping = false;
    isCardSelected.clear();
    countInCorrect.clear();
    score = 0;
    matchCorrect = 0;
    countCorrect = [];
    // ignore: avoid_function_literals_in_foreach_calls
    state.bundleCardModel.cardObject.forEach((selectedCard) {
      selectedCard.isSelected = false;
    });

    emit(MemorizeState(bundleCardModel: randomBundleCard(), score: score));
  }

  void onRestartGameTap() {
    state.bundleCardModel.cardObject.shuffle();
    isFlipping = false;
    isCardSelected.clear();
    countInCorrect.clear();
    score = 0;
    matchCorrect = 0;
    countCorrect = [];
    // ignore: avoid_function_literals_in_foreach_calls
    state.bundleCardModel.cardObject.forEach((selectedCard) {
      selectedCard.isSelected = false;
    });

    emit(MemorizeState(bundleCardModel: state.bundleCardModel, score: score));
  }

  _showGameOverDialog(context) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      body: Center(child: Text('Finish! | Your score : ${state.score}'),),
      btnOkOnPress: () {
        onNewGameTap();
      },
    ).show();
  }

}

class MemorizeState {
  final BundleCardModel bundleCardModel;
  final int score;

  const MemorizeState({required this.bundleCardModel, required this.score});
}

class IsCardSelected {
  final int cardIndex;
  final String cardEmoji;
  
  IsCardSelected({required this.cardIndex, required this.cardEmoji});
}