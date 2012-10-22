import 'dart:html';
import 'view.dart';
import 'controller.dart';

void main() {
  LocalWindow myWindow = window;
  GameView gameView = new GameView(myWindow);
  GameController gameController = new GameController(gameView);
}


