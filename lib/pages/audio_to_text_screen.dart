import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioToTextScreen extends StatefulWidget {
  const AudioToTextScreen({super.key});

  @override
  _AudioToTextScreenState createState() => _AudioToTextScreenState();
}

class _AudioToTextScreenState extends State<AudioToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the mic button and start speaking...";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Status: $status"),
      onError: (error) => print("Error: $error"),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        localeId: "ar_SA", // Specify the locale for Arabic
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
      );
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio to Text Converter'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        backgroundColor: Colors.blue,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 150),
        child: Text(
          _text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
