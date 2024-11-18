// import 'package:flutter_sound/flutter_sound.dart';
//
// class AudioRecorder {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool _isRecorderInitialized = false;
//
//   // Initialize the recorder
//   Future<void> initRecorder() async {
//     await _recorder.openRecorder();
//     _isRecorderInitialized = true;
//   }
//
//   // Start recording method
//   Future<void> startRecording(String filePath) async {
//     if (!_isRecorderInitialized) {
//       throw Exception("Recorder is not initialized.");
//     }
//
//     try {
//       await _recorder.startRecorder(
//         toFile: filePath,
//         codec: Codec.aacADTS, // You can change the codec if needed
//       );
//       print("Recording started.");
//     } catch (e) {
//       print("Error starting recording: $e");
//     }
//   }
//
//   // Stop recording method
//   Future<String?> stopRecording() async {
//     if (!_isRecorderInitialized) {
//       throw Exception("Recorder is not initialized.");
//     }
//
//     try {
//       final path = await _recorder.stopRecorder();
//       print("Recording stopped. File saved at: $path");
//       return path; // Returns the path of the recorded file
//     } catch (e) {
//       print("Error stopping recording: $e");
//       return null;
//     }
//   }
//
//   // Dispose recorder
//   Future<void> disposeRecorder() async {
//     await _recorder.closeRecorder();
//     _isRecorderInitialized = false;
//   }
// }
