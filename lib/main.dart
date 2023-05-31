import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:chatview/src/widgets/chat_bubble_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: const UIDemoPage(),
        ));
  }
}

const marginHorizontal = 20.0;

class UIDemoPage extends StatefulWidget {
  const UIDemoPage({Key? key}) : super(key: key);

  @override
  State<UIDemoPage> createState() => _UIDemoPageState();
}

class _UIDemoPageState extends State<UIDemoPage> with TickerProviderStateMixin {
  static const _backgroundColor = Color(0xFFF15BB5);

  static const _colors = [
    // Color(0xFFFEE440),
    Color(0xFF00BBF9),
  ];

  static const _durations = [
    // 5000,
    4000,
  ];

  static const _heightPercentages = [
    // 0.65,
    0.36,
  ];

  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-0.2, 0.0),
    ).animate(
      CurvedAnimation(
        curve: Curves.easeOut,
        parent: _animationController!,
      ),
    );
  }

  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    final message = Message(
        message: 'hello, text', createdAt: DateTime.now(), sendBy: 'hello');
    final controller = SiriWaveController(
      amplitude: 1,
      color: Colors.red,
      frequency: 4,
      speed: 0.15,
    );
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      color: Colors.white,
      child: Column(children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 80),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: const Text(
                      '<< Slide to cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.yellow,
                      child: SiriWave(controller: controller),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTapDown: (e) {
                  print('tap down');
                  setState(() {
                    isRecording = true;
                  });
                },
                onTapUp: (e) {
                  print('tap up');
                  setState(() {
                    isRecording = false;
                  });
                },
                onTapCancel: () {
                  print('cancel');
                  setState(() {
                    isRecording = false;
                  });
                },
                child: isRecording
                    ? AvatarGlow(
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 1000),
                        repeatPauseDuration: Duration(milliseconds: 10),
                        glowColor: Colors.blue,
                        endRadius: 45.0,
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 25.0,
                            child: Icon(Icons.mic, size: 30),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(20),
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 25.0,
                            child: Icon(Icons.mic, size: 30),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 100,
          child: WaveWidget(
            config: CustomConfig(
              colors: _colors,
              durations: _durations,
              heightPercentages: _heightPercentages,
            ),
            waveFrequency: 5,
            wavePhase: 3,
            backgroundColor: _backgroundColor,
            size: Size(double.infinity, double.infinity),
            waveAmplitude: 5,
          ),
        ),
        _buildCard(
          backgroundColor: Colors.purpleAccent,
          config: CustomConfig(
            gradients: [
              [Colors.red, Color(0xEEF44336)],
              [Colors.red[800]!, Color(0x77E57373)],
              [Colors.orange, Color(0x66FF9800)],
              [Colors.yellow, Color(0x55FFEB3B)]
            ],
            // colors: [
            //   Colors.red,
            //   Colors.red[800]!,
            //   Colors.orange,
            //   Colors.yellow
            // ],
            durations: [35000, 19440, 10800, 6000],
            heightPercentages: [0.20, 0.23, 0.25, 0.30],
            gradientBegin: Alignment.bottomLeft,
            gradientEnd: Alignment.topRight,
          ),
        ),
        SquigglyWaveform(
          samples: [10.1, 10.2, 0.1, 0.5],
          height: 100,
          strokeWidth: 2,
          width: 5 * 5,
        ),
        ChatBubbleWidget(
          slideAnimation: _slideAnimation,
          key: message.key,
          message: message,
          onLongPress: (p0, p1) {},
          onSwipe: (message) {},
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(top: 140, left: 4, right: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: SocialMediaRecorder(
              sendRequestFunction: (soundFile) {
                // print("the current path is ${soundFile.path}");
              },
              encode: AudioEncoderType.AAC,
            ),
          ),
        ),
      ]),
    );
  }

  _buildCard({
    required Config config,
    Color? backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
    double height = 152.0,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      child: Card(
        elevation: 12.0,
        margin: EdgeInsets.only(
            right: marginHorizontal, left: marginHorizontal, bottom: 16.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: WaveWidget(
          config: config,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          size: Size(double.infinity, double.infinity),
          waveAmplitude: 0,
        ),
      ),
    );
  }
}
