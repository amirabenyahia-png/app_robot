import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var test = false;
  static const D1 = ["gauche", "left"];
  static const D2 = ["right", "droite"];
  static const D3 = ["up", "au dessus"];
  static const D4 = ["down", "en dessous"];
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  int x = 0;
  int y = 0;
  int z = 0;
  int w = 0;

// function of comparaison between listened word and in dictionnaire
  void findArea(String s) {
    for (String i in D1) {
      if (s == i) {
        setState(() {
          x = 1;
        });
      } else {
        setState(() {
          x = 0;
        });
      }
    }
    // for (String i in D2) {
    //   if (s == i) {
    //     setState(() {
    //       y = 1;
    //     });
    //   } else {
    //     setState(() {
    //       y = 0;
    //     });
    //   }
    // }
    // for (String i in D3) {
    //   if (s == i) {
    //     setState(() {
    //       w = 1;
    //     });
    //   } else {
    //     setState(() {
    //       w = 0;
    //     });
    //   }
    // }
    // for (String i in D4) {
    //   if (s == i) {
    //     setState(() {
    //       z = 1;
    //     });
    //   } else {
    //     setState(() {
    //       z = 0;
    //     });
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
    findArea(_lastWords);
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Speech Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Recognized words:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    // If listening is active show the recognized words
                    _speechToText.isListening
                        ? '$_lastWords'
                        // If listening isn't active but could be tell the user
                        // how to start it, otherwise indicate that speech
                        // recognition is not yet ready or not supported on
                        // the target device
                        : _speechEnabled
                            ? 'Tap the microphone to start listening...'
                            : 'Speech not available',
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed:
                    // If not yet listening for speech start, otherwise stop
                    _speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                tooltip: 'Listen',
                child: Icon(
                    _speechToText.isNotListening ? Icons.mic_off : Icons.mic),
              ),
              Text("$x"),
            ],
          ),
        ),
        floatingActionButton: FabCircularMenu(children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_left_outlined),
              onPressed: () {
                setState(() {
                  x = 1;
                });
              }),
          IconButton(
              icon: Icon(Icons.arrow_right_outlined),
              onPressed: () {
                setState(() {
                  y = 1;
                });
              }),
          IconButton(
              icon: Icon(Icons.keyboard_arrow_down_outlined),
              onPressed: () {
                setState(() {
                  z = 1;
                });
              }),
          IconButton(
              icon: Icon(Icons.arrow_upward_outlined),
              onPressed: () {
                setState(() {
                  w = 1;
                });
              }),
        ]));
  }
}
