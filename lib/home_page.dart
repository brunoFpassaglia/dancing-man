import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SMIInput<bool>? _backPackTrigger;
  SMIInput<bool>? _polichineloTrigger;
  SMIInput<bool>? _rebolaTrigger;
  SMIInput<bool>? _stopTrigger;
  Artboard? _dancingManArtboard;
  String _selectedBackgroud = 'lib/assets/dancing.gif';
  final List<String> _backGrounds = [
    'lib/assets/dancing.gif',
    'lib/assets/cat.gif',
    'lib/assets/dog.gif',
    'lib/assets/sunset.gif',
  ];

  @override
  void initState() {
    super.initState();
    rootBundle.load('lib/assets/dancing_doll.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      final controller =
          StateMachineController.fromArtboard(artboard, 'DancingMan');
      if (controller != null) {
        artboard.addController(controller);
        _backPackTrigger = controller.findInput('triggerBackPack');
        _polichineloTrigger = controller.findInput('triggerPolichinelo');
        _rebolaTrigger = controller.findInput('triggerRebola');
        _stopTrigger = controller.findInput('exit');
      }
      setState(() => _dancingManArtboard = artboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dancing StickMan'),
      ),
      body: _dancingManArtboard == null
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 450,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset(_selectedBackgroud)),
                    ),
                    _dancingManArtboard != null
                        ? Positioned(
                            bottom: 0,
                            left: 40,
                            child: SizedBox(
                              height: 250,
                              width: 250,
                              child: Rive(
                                fit: BoxFit.fill,
                                artboard: _dancingManArtboard!,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () => changeAnimation(_backPackTrigger!),
                        child: Row(
                          children: [
                            Icon(Icons.music_note),
                            Text('Dance'),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () => changeAnimation(_rebolaTrigger!),
                        child: Row(
                          children: [
                            Icon(Icons.cached),
                            Text(
                              'Rebole',
                            ),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () => changeAnimation(_polichineloTrigger!),
                        child: Row(
                          children: [
                            Icon(Icons.accessibility_new),
                            Text('Polichinelo'),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () => changeAnimation(_stopTrigger!),
                        child: Row(
                          children: [
                            Icon(Icons.stop),
                            Text('Pare'),
                          ],
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          var index = _backGrounds.indexOf(_selectedBackgroud);
                          if (_backGrounds.asMap().containsKey(index - 1)) {
                            setState(() {
                              _selectedBackgroud = _backGrounds[index - 1];
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_back)),
                    IconButton(
                        onPressed: () {
                          var index = _backGrounds.indexOf(_selectedBackgroud);
                          if (_backGrounds.asMap().containsKey(index + 1)) {
                            setState(() {
                              _selectedBackgroud = _backGrounds[index + 1];
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_forward))
                  ],
                )
              ],
            ),
    );
  }

  void changeAnimation(SMIInput<bool> animation) {
    animation.value = true;
  }
}
