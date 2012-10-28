//# Immutable singleton
//class App.Models.Rank
//  constructor: (@value) ->
//
//  letter: ->
//    'A23456789TJQK'.charAt(@value)
//  nextLower: ->
//    if @value is 0 then null else App.Models.ranks[@value - 1]
//  nextHigher: ->
//    if @value is 12 then null else App.Models.ranks[@value + 1]
List ranks = [
              new RankModel(0),
              new RankModel(1),
              new RankModel(2),
              new RankModel(3),
              new RankModel(4),
              new RankModel(5),
              new RankModel(6),
              new RankModel(7),
              new RankModel(8),
              new RankModel(9),
              new RankModel(10),
              new RankModel(11),
              new RankModel(12),
              ];
class RankModel {
  var rankValue;
  RankModel(this.rankValue){
    letter = rankValue == 8 ? '10' :'23456789TJQKA'[rankValue];
    //nextLower = (rankValue == 0 ? null : ranks[rankValue - 1]);
    //nextHigher = (rankValue == 12 ? null : ranks[rankValue + 1]);
  }
  
  var letter;
  var nextLower;
  var nextHigher;
 
  
}
