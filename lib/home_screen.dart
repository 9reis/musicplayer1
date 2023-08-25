import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:musicplayer1/utils/constantes.dart';
import 'package:musicplayer1/utils/utils.dart';
import 'package:musicplayer1/widgets/audio_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPlaying = false;
  late final AudioPlayer player;
  late final AssetSource music;

  Duration _duration = const Duration();
  Duration _position = const Duration();
  int? selectedLoop = 1;

  dropDown() {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(right: 10),
      width: size.width * 0.35,
      decoration: BoxDecoration(
        color: kGrey,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: kBlack,
        ),
      ),
      child: DropdownButton<int>(
        value: selectedLoop,
        onChanged: (value) {
          setState(() {
            selectedLoop = value;
          });
        },
        hint: Center(
            child: Text(
          'Loop',
          style: TextStyle(color: kBlack),
        )),
        // Hide the default underline
        underline: Container(),
        // set the color of the dropdown menu
        dropdownColor: kGrey,
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: kBlack,
          size: 35,
        ),
        isExpanded: true,

        // The list of options
        items: _loop
            .map((e) => DropdownMenuItem(
                  value: e.toInt(),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      e.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ))
            .toList(),

        // Customize the selected item
        selectedItemBuilder: (BuildContext context) => _loop
            .map((e) => Center(
                  child: Text(
                    e.toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: kBlack,
                        fontWeight: FontWeight.bold),
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    player = AudioPlayer();
    music = AssetSource('audios/teste.mp3');
    // initPlayer();

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  // Future initPlayer() async {
  //   player = AudioPlayer();
  //   music = AssetSource('audios/teste.mp3');

  //   // set a callback for changing duration
  //   player.onDurationChanged.listen((Duration d) {
  //     setState(() => _duration = d);
  //   });

  //   // set a callback for position change
  //   player.onPositionChanged.listen((Duration p) {
  //     setState(() => _position = p);
  //   });

  //   // set a callback for when audio ends
  //   player.onPlayerComplete.listen((_) {
  //     setState(() => _position = _duration);
  //   });
  // }

  int repeatCount = 5;
  int currentRepeat = 0;

  void playAudio(int numberOfTimes) async {
    Duration time = const Duration();
    for (int i = 0; i < numberOfTimes; i++) {
      await player.play(music);
      await player.getDuration().then((timeOfAudio) {
        // Pega o tempo da musica
        if (timeOfAudio != null) {
          time = timeOfAudio;
        }
      });
      // Tempo da musica + 1seg
      await Future.delayed(time + const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //const AudioInfo(),
            const SizedBox(height: 50),
            // Slider(
            // value: _position.inSeconds.toDouble(),
            // onChanged: (value) async {
            //   await player.seek(Duration(seconds: value.toInt()));
            //   setState(() {});
            // },
            // min: 0,
            // max: _duration.inSeconds.toDouble(),
            // inactiveColor: Colors.grey,
            // activeColor: Colors.red,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text(_duration.format()),
            //   ],
            // ),
            // const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    player.seek(Duration(seconds: _position.inSeconds - 10));
                    setState(() {});
                  },
                  child: Image.asset('assets/icons/rewind.png'),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () => playAudio(selectedLoop!.toInt()),
                  child: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.red,
                    size: 100,
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    player.seek(Duration(seconds: _position.inSeconds + 10));
                    setState(() {});
                  },
                  child: Image.asset('assets/icons/forward.png'),
                ),
              ],
            ),
            dropDown(),
          ],
        ),
      ),
    );
  }

  List<int> _loop = [1, 2, 3, 4];
}
