
class TableView {
  List players;
  Element rootElement;
  TableView(){
    rootElement = query('#card-table');
    players = new List();
  }
  
  renderTable(var hands){
    //rootElement.innerHTML = '';
    PlayerView.playerCounter = 1;
    for(final player in hands){
      players.add(player);
      PlayerView.renderPlayer(player, rootElement);
    }

  }
}
