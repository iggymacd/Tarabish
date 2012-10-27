library view;
import 'dart:html';
import 'dart:isolate';
import 'controller.dart';
part 'player_view.dart';
part 'table_view.dart';
part 'game_view.dart';

launchWorker(){
  port.receive((var msg, SendPort replyTo){
    //print(query('#choose-players').text);
    //GameView gameView = new GameView();
    //query('#play').on.click.add((Event event) {
      //var numOfPlayers = int.parse(query('#choose-players').text);
      //var game = new PlayController(numOfPlayers);
      //game.setupTable();
    //});

    replyTo.call('reply back');
  });

}