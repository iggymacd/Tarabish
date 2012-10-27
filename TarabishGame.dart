import 'dart:html';
import 'dart:isolate';
import 'view.dart';
import 'controller.dart';

void main() {
  //var myWindow = window;
  //GameController gameController = new GameController();
  var viewWorker = spawnFunction(launchWorker);
  port.receive((var msg, SendPort replyTo){
    print('in main receive...$msg');
    //port.close();
  });
  viewWorker.send('hello there', port.toSendPort());
}


