//library model;

class GameModel {
  var numberOfPlayers;
  List<PlayerModel> players;
  List<CardModel> deck;
  
  GameModel(this.numberOfPlayers){
    players = new List(numberOfPlayers);
    for(num i = 0 ; i < numberOfPlayers ; i++){
      //print('in currentPlayer');
      players[i] = new PlayerModel(i.toString());
    }
    //if tarabish, remove 6,5,4,3,2
    //if()
    deck = shuffle(createDeck());
  }

  List createDeck() {
    List<CardModel> result = new List<CardModel>();
    for (final currentRank in ranks){
      if(['5','4','3','2'].indexOf(currentRank.letter) != -1){
        continue;
      }
      for(final currentSuit in suits){
        result.add(new CardModel(currentRank, currentSuit));
      }
    }
    return result;
  }

  List deal() {
    List deckCopy = new List.from(deck);
    var spareCards = deckCopy.length % numberOfPlayers; 
//  # Deal the cards evenly
    while ((deckCopy.length - spareCards) > 0){
        for (var i = 0;  i < players.length; i++){
         // print(players[i]);
          players[i].cards.add(deckCopy.removeLast());
        }
    }

//  # Stash the left-over cards
    //spareCards = deckCopy;

//  # Return players/hands/cards
    return players;  
  }
  
  
}
