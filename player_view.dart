//library view;
class PlayerView {
  static num playerCounter = 1;
  //PlayerModel player;
  PlayerView();
  static Map positions = {"0":"north","1":"west","2":"east","3":"south"};
  static void renderPlayer(var player, Element rootElement){
    //var playerCounter = 0;
    DivElement handDiv;
    DivElement rowDiv;
    HeadingElement playerHeading;// = new HeadingElement.h2();
    SpanElement cardSpan;// = new Element.tag('span');
    SpanElement rankSpan;
    SpanElement suitSpan;
    DivElement wellDiv;// = new Element.tag('div');
    var position = '#${positions[player.name]}';
    print(position);
    print(rootElement.id);
    wellDiv = query(position);//new Element.tag('div');
    wellDiv.innerHTML = '';
    //print(wellDiv);
    //wellDiv.classes.add('well');
    //wellDiv.classes.add('span${player.name == '0' || player.name == '3' ? '3 offset1' :'3'}');
    playerHeading = new HeadingElement.h2();
    playerHeading.innerHTML = 'Player ${playerCounter++}';
    wellDiv.insertAdjacentElement('beforeend', playerHeading);
    handDiv = new Element.tag('div');
    handDiv.classes.add('hand');
    for(final card in player.cards){
      cardSpan = new Element.tag('span');
      cardSpan.classes.add('card');
      cardSpan.classes.add(player.name != '3' ? 'back' :card.suit.name);
      rankSpan = new Element.tag('span');
      rankSpan.classes.add('rank');
      rankSpan.innerHTML = player.name != '3' ? '&nbsp;' :card.rank.letter;
      suitSpan = new Element.tag('span');
      suitSpan.classes.add('suit');
      suitSpan.innerHTML = '&${player.name != '3' ? card.suit.back :card.suit.name};';
      cardSpan.insertAdjacentElement('afterbegin', rankSpan);
      rankSpan.insertAdjacentElement('afterend', suitSpan);
      handDiv.insertAdjacentElement('beforeend', cardSpan);
    }
    playerHeading.insertAdjacentElement('afterend', handDiv);
//    if(player.name == '0' || player.name == '3'){
//      rowDiv = new Element.tag('div');
//      rowDiv.classes.add('row');
//      rowDiv.insertAdjacentElement('afterbegin', wellDiv);
//      rootElement.insertAdjacentElement('beforeend', rowDiv);
//    }else{
      //rootElement.insertAdjacentElement('beforeend', wellDiv);
//    }
    

  }
}
