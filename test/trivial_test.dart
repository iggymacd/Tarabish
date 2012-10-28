import "package:unittest/unittest.dart";
import '../web/model.dart';

main() {
  test('this is a test', () {
    GameModel gameModel = new GameModel(4);
    List result = gameModel.createDeck();
    int x = 2 + 3;
    expect(x, equals(5));
  });
}