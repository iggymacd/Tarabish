//# Immutable singleton
//class App.Models.Suit
//  constructor: (@value) ->
//
//  letter: ->
//    'CDHS'.charAt(@value) # clubs, diamonds, hearts, spades
//  color: ->
//    if @letter() is 'C' or @letter() is 'S' then 'black' else 'red'
//  name: ->
//    if @letter() is 'C'
//      'clubs'
//    else if @letter() is 'D'
//      'diams'
//    else if @letter() is 'H'
//      'hearts'
//    else
//      'spades'
List suits = [
              new SuitModel(0),
              new SuitModel(1),
              new SuitModel(2),
              new SuitModel(3)
              ];
class SuitModel {
  var suitValue;
  SuitModel(this.suitValue){
    letter = 'CDHS'[suitValue];
    back = 'nbsp';
    color = (letter == 'C' || letter == 'S' ? 'black' : 'red' );
    if(letter == 'C'){
      name = 'clubs';
    }else if(letter == 'D'){
      name = 'diams';
    }else if(letter == 'H'){
      name = 'hearts';
    }else{
      name = 'spades';
    }
  }
  var letter;
  var color;
  var name;
  var back;
}
