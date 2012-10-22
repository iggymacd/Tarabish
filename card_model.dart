//constructor: (@rank, @suit) ->
//    @id = "id#{_nextId++}"
class CardModel {
  static var nextId = 0;
  var id;
  var rank;
  var suit;
  CardModel(this.rank, this.suit){
    id = 'id#${nextId++}';
  }
  
}
