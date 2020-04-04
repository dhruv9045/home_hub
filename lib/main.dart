import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homehub/Gas_Automation.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Hub',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Gas Automation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  String broker   = 'postman.cloudmqtt.com';
  int port        =  12072;
  String username = 'zvibyzxz';
  String passward = 'YHJqD8Vx7DeB';
  String clientId = '9045242352';

  final String relayTopic ="CHIPIDESP/relay/(any number out of total relay)/state/";
  final String fanTopic ="CHIPIDESP/relay/(any number out of total fan)/state/";
  final String topic = "CHIPID/offline";
  final String pubTopic = "CHIPID/offline/";
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  var txt = TextEditingController();
/*
  double _temp = 20;
*/

  StreamSubscription subscription;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: new Drawer(
          child: new ListView(
            children: <Widget> [
           /*   new UserAccountsDrawerHeader(
              accountName:new Text("Dks"),
              accountEmail:new Text("shgdk.com"),
              currentAccountPicture:new GestureDetector(
                onTap:()=>print("This is the current user"),
                child:new CircleAvatar(
                  backgroundImage:new NetworkImage("url"),
                ),
              ),
              otherAccountPicture:<widget>[
              new GestureDetector(
                onTap:()=>print("This is the other user"),
                child:new CircleAvatar(
                  backgroundImage:new NetworkImage("url"),
                ),
              ),
              ],
              decoration:new BoxDecoration(
              image:new DecorationImage(
                image:new NetworkImage("url"),
              ),
              ),
              ),*/
              new DrawerHeader(
                child: new Text('Header'),
                decoration:new BoxDecoration(
                    image:new DecorationImage(
                        image:new NetworkImage("url")
                    )
                ),             ),
              new ListTile(
                title: new Text('Home_Device'),
                onTap: ()
                {
                  Navigator.of(context).pop();
                },
              ),
              new ListTile(
                title: new Text('Gas_Device'),
                onTap: ()
                {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new GasPage("Gas_Device")));
                }
              ),

              new Divider(),
              new ListTile(
                title: new Text('About'),
                onTap: () {},
              ),
            ],
          )
      ),
      body: Column(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children:<Widget>[
          Text('Relay Buttons'),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: RaisedButton(
                              onPressed: (_relay1),
                            child: Text('Relay 1'),
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: (_relay2),
                              child: Text('Relay 2'),
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: (_relay3),
                              child: Text('Relay 3'),
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              onPressed: (_relay4),
                              child: Text('Relay 4'),
                            ),
                          ),
                        ],
                    ),
          Text('Fan Buttons'),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            onPressed: (_fan1),
                            child: Text('Fan 1'),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: (_fan2),
                            child: Text('Fan 2'),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: (_fan3),
                            child: Text('Fan 3'),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: (_fan4),
                            child: Text('Fan 4'),
                          ),
                        ),
                      ],
                    ),
        Text(
        'Click on Add Button to connect to MQTT:',
      ),
      Text(
        'Connect MQTT Server',
        style: Theme.of(context).textTheme.display1,
      ),
          TextField(
            controller: txt,
          ),
      ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0,),
        color: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(_connect),
        tooltip: 'Play',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _relay1() {
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("1");
    client.publishMessage(relayTopic, MqttQos.atMostOnce, builder.payload);
  }
  void _relay2(){
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("2");
    client.publishMessage(relayTopic, MqttQos.atMostOnce, builder.payload);
  }
  void _relay3(){
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("3");
    client.publishMessage(relayTopic, MqttQos.atMostOnce, builder.payload);
  }
  void _relay4(){
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("4");
    client.publishMessage(relayTopic, MqttQos.atMostOnce, builder.payload);
  }
  ///Fan Buttons
  void _fan1() {
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("1");
    client.publishMessage(relayTopic, MqttQos.atMostOnce, builder.payload);
  }
  void _fan2(){
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("2");
    client.publishMessage(relayTopic, MqttQos.atMostOnce, builder.payload);
  }
  void _fan3(){
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("3");
    client.publishMessage(relayTopic, MqttQos.atMostOnce, builder.payload);
  }
  void _fan4(){
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("4");
    client.publishMessage(relayTopic, MqttQos.atMostOnce, builder.payload);
  }
  /// Ok, lets try a subscription
  void _subscribeToTopic() {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic.trim()}');
      client.subscribe(topic, mqtt.MqttQos.atMostOnce);
    }
  }
  void _connect() async {

    client = mqtt.MqttClient(broker, '');
    client.port = port;
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
       /* .withWillTopic("Already") // If you set this you must set a will message
        .withWillMessage("Connected")*/
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.

    try {
      await client.connect(username, passward);
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
      builder.addString("0");
      client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload);
      Fluttertoast.showToast(
          msg: "connected",
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0
      );
      setState(() {
        connectionState = client.connectionState;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client.updates.listen(_onMessage);
    _subscribeToTopic();
  }

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    final MqttClientPayloadBuilder builder = new MqttClientPayloadBuilder();
    builder.addString("1");
    client.publishMessage(pubTopic, MqttQos.atMostOnce, builder.payload);
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState = client.connectionState;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> c) {
    print(c.length);
    final mqtt.MqttPublishMessage recMess = c[0].payload as mqtt.MqttPublishMessage;
    final String message = mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('[MQTT client] MQTT message: topic is <${c[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client.connectionState);
    print("[MQTT client] message with topic: ${c[0].topic}");
    print("[MQTT client] message with message: ${message}");
if(topic == "${c[0].topic}")
  {
    if("0"== "${message}") {
      print("[MQTT client] Device ONLINE");
      txt.text="Clien ONLINE";
    }
    if("1"== "${message}") {
      print("[MQTT client] Device OFFLINE");
      txt.text="Clien OFLINE";
    }
  }
  }
}
