import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3_plus/record_mp3_plus.dart';

class SoundRecordNotifier extends ChangeNotifier {
  int _localCounterForMaxRecordTime = 0;
  GlobalKey key = GlobalKey();
  int? maxRecordTime;

  Timer? _timer;
  Timer? _timerCounter;

  double last = 0;
  String initialStorePathRecord = "";

  /// Record mp3 instance
  RecordMp3 recordMp3 = RecordMp3.instance;

  bool _isAcceptedPermission = false;

  double currentButtonHeihtPlace = 0;
  bool isLocked = false;
  bool isShow = false;
  late int second;
  late int minute;
  late bool buttonPressed;
  late double edge;
  late bool loopActive;
  late bool startRecord;
  late double heightPosition;
  late bool lockScreenRecord;
  late String mPath;

  Function()? startRecording;
  Function(File soundFile, String time) sendRequestFunction;
  Function(String time)? stopRecording;

  SoundRecordNotifier({
    required this.stopRecording,
    required this.sendRequestFunction,
    required this.startRecording,
    this.edge = 0.0,
    this.minute = 0,
    this.second = 0,
    this.buttonPressed = false,
    this.loopActive = false,
    this.mPath = '',
    this.startRecord = false,
    this.heightPosition = 0,
    this.lockScreenRecord = false,
    this.maxRecordTime,
  });

  void _mapCounterGenerater() {
    _timerCounter = Timer(const Duration(seconds: 1), () {
      _increaseCounterWhilePressed();
      if (buttonPressed) _mapCounterGenerater();
    });
  }

  finishRecording() {
    if (buttonPressed) {
      if (second > 1 || minute > 0) {
        String path = mPath;
        String _time = "$minute:$second";
        sendRequestFunction(File(path), _time);
        stopRecording?.call(_time);
      }
    }
    resetEdgePadding();
  }

  resetEdgePadding() async {
    _localCounterForMaxRecordTime = 0;
    isLocked = false;
    edge = 0;
    buttonPressed = false;
    second = 0;
    minute = 0;
    isShow = false;
    key = GlobalKey();
    heightPosition = 0;
    lockScreenRecord = false;
    _timer?.cancel();
    _timerCounter?.cancel();

    recordMp3.stop();

    stopRecording?.call('0:0');
    notifyListeners();
  }

  Future<String> getFilePath() async {
    String _sdPath = "";
    Directory tempDir = await getTemporaryDirectory();
    _sdPath =
    initialStorePathRecord.isEmpty ? tempDir.path : initialStorePathRecord;
    var d = Directory(_sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    DateTime now = DateTime.now();
    String convertedDateTime =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    convertedDateTime = convertedDateTime.replaceAll(":", ".");
    String storagePath = "$_sdPath/$convertedDateTime.mp3";
    mPath = storagePath;
    return storagePath;
  }

  setNewInitialDraggableHeight(double newValue) {
    currentButtonHeihtPlace = newValue;
  }

  updateScrollValue(Offset currentValue, BuildContext context) async {
    if (buttonPressed) {
      final x = currentValue;
      double hightValue = currentButtonHeihtPlace - x.dy;
      if (hightValue >= 50) {
        isLocked = true;
        lockScreenRecord = true;
        hightValue = 50;
        notifyListeners();
      }
      if (hightValue < 0) hightValue = 0;
      heightPosition = hightValue;
      lockScreenRecord = isLocked;
      notifyListeners();

      try {
        RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        if (position.dx <= MediaQuery.of(context).size.width * 0.6) {
          String _time = "$minute:$second";
          stopRecording?.call(_time);
          resetEdgePadding();
        } else {
          if (last < x.dx) {
            edge = edge -= x.dx / 200;
            if (edge < 0) edge = 0;
          } else if (last > x.dx) {
            edge = edge += x.dx / 200;
          }
          last = x.dx;
        }
      } catch (e) {}
      notifyListeners();
    }
  }

  _increaseCounterWhilePressed() async {
    if (loopActive) return;

    loopActive = true;
    if (maxRecordTime != null) {
      if (_localCounterForMaxRecordTime >= maxRecordTime!) {
        loopActive = false;
        finishRecording();
      }
      _localCounterForMaxRecordTime++;
    }
    second++;
    if (second == 60) {
      second = 0;
      minute++;
    }
    notifyListeners();
    loopActive = false;
    notifyListeners();
  }

  record(Function()? startRecord) async {
    if ((await Permission.microphone.isGranted) != true) {
      await Permission.microphone.request();
      await Permission.storage.request();
      _isAcceptedPermission = true;
    } else {
      buttonPressed = true;
      String recordFilePath = await getFilePath();
      _timer = Timer(const Duration(milliseconds: 900), () {
        recordMp3.start( recordFilePath, (error) {
          print('error: $error');
        });
      });

      startRecord?.call();
      _mapCounterGenerater();
      notifyListeners();
    }
    notifyListeners();
  }

  voidInitialSound() async {
    startRecord = false;
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        _isAcceptedPermission = true;
      }
    }
  }
}