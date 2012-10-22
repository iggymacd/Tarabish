
class GameController {
  GameView gameView;
  GameController(this.gameView){
    gameView.currentWindow.document.query('#play').on.click.add((Event event) {
      var players = int.parse(gameView.currentWindow.document.query('#choose-players').text);
      var game = new PlayController(players);
      game.setupTable();
    });
  }
  
  
  
}


//setupGame(Event event) {
//  var players = int.parse(query('#choose-players').text);
//  var game = new PlayController(players);
//  game.setupTable();
//}