
class GameView {
  //var currentWindow;
  GameView(){
    query('#play').on.click.add((Event event) {
      var numOfPlayers = int.parse(query('#choose-players').text);
      var game = new PlayController(numOfPlayers);
      game.setupTable();
    });
    
  }
}
