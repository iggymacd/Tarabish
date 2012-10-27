
class TableView {

  Element rootElement;
  TableView(){
    rootElement = query('#card-table');
  }
  
  renderTable(var hands){
    //rootElement.innerHTML = '';
    PlayerView.playerCounter = 1;
    for(final player in hands){
      PlayerView.renderPlayer(player, rootElement);
    }

  }
}
