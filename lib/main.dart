import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:owowen_wilson/sounds.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'FredokaOne',
      ),
      home: MyHomePage(title: 'Owen Wilson Wowboard'),
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
  /// Owen's Faces
  List<String> _headshots = [
    'assets/images/owen1.png',
    'assets/images/owen2.png',
    'assets/images/owen3.png',
    'assets/images/owen4.png',
    'assets/images/owen5.png',
    'assets/images/owen6.png',
  ];

  /// Owen's WOWs
  final List _wows = WowSounds().wows;

  /// Audio Cache
  AudioCache audioCache;
  AudioPlayer audioPlayer;
  int indexIsPlaying;

  @override
  void initState() {
    super.initState();
    initSounds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Click a face, hear a WOW!'),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 15,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              child: Center(
                child: AnimatedContainer(
                  width: indexIsPlaying == index ? 120 : 80,
                  height: indexIsPlaying == index ? 120 : 80,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.bounceOut,
                  decoration: BoxDecoration(
                    color: indexIsPlaying == index
                        ? Colors.white
                        : Colors.yellow[500],
                    borderRadius: new BorderRadius.circular(100.0),
                    image: new DecorationImage(
                      image: new AssetImage(_headshots[index % 5]),
                      fit: BoxFit.fill,
                    ),
                    border: new Border.all(
                        color: indexIsPlaying == index
                            ? Colors.yellow
                            : Colors.transparent,
                        width: 2.0,
                        style: BorderStyle.solid),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: Offset(0, 10.0),
                        blurRadius: 10.0,
                      )
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text('${index + 1}'),
                  ),
                ),
              ),
              onTap: () {
                if (mounted) {
                  setState(() {
                    playSound(_wows[index]);
                    indexIsPlaying = index;
                  });
                }
              },
            ),
            padding: const EdgeInsets.all(20),
          ),
        ],
      ),
    );
  }

  void initSounds() async {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioCache.loadAll(_wows);
  }

  void playSound(wow) async {
    var fileName = wow;
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      audioPlayer.stop();
    }
    audioPlayer = await audioCache.play(fileName);
  }

  void stopSound(wow) {
    audioPlayer.stop();
  }
}
