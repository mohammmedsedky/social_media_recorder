library social_media_recorder;

import 'package:flutter/material.dart';
import 'package:social_media_recorder/provider/sound_record_notifier.dart';

/// This Class Represent Icons To swap top to lock recording
class LockRecord extends StatefulWidget {
  /// Object From Provider Notifier
  final SoundRecordNotifier soundRecorderState;
  // ignore: sort_constructors_first

  final Widget? lockIcon;
  const LockRecord({
    this.lockIcon,
    required this.soundRecorderState,
    Key? key,
  }) : super(key: key);
  @override
  _LockRecordState createState() => _LockRecordState();
}

class _LockRecordState extends State<LockRecord> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    /// If click the Button Then send show lock and un lock icon
    if (!widget.soundRecorderState.buttonPressed) return Container();
    return AnimatedPadding(
      duration: const Duration(seconds: 1),
      padding:
          EdgeInsets.all(widget.soundRecorderState.second % 2 == 0 ? 0 : 8),
      child: Transform.translate(
        offset: const Offset(0, -75),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            opacity: widget.soundRecorderState.edge >= 50 ? 0 : 1,
            child: Container(
              height: 50 - widget.soundRecorderState.heightPosition < 0
                  ? 0
                  : 50 - widget.soundRecorderState.heightPosition,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xffF3F1F1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],

              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.lockIcon ??
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                              opacity: widget.soundRecorderState.second % 2 != 0
                                  ? 0
                                  : 1,
                              child: const Icon(Icons.lock_outline_rounded,color: Colors.black,)),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                              opacity: widget.soundRecorderState.second % 2 == 0
                                  ? 0
                                  : 1,
                              child: const Icon(Icons.lock_open_rounded,color: Colors.black,)),
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
