import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioToSignScreen extends StatefulWidget {
  const AudioToSignScreen({super.key});

  @override
  State<AudioToSignScreen> createState() => _AudioToSignScreenState();
}

class _AudioToSignScreenState extends State<AudioToSignScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  List<String> allTexts = [];
  String _image = "assets/videos/intro.gif";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startListening() async {
    setState(() => _isListening = true);
    bool available = await _speech.initialize(
      onStatus: (status) => print("Status: $status"),
      onError: (error) => print("Error: $error"),
    );
    allTexts = [];

    if (available) {
      await _speech.listen(
        localeId: "ar_SA",
        onResult: (result) {
          _text = result.recognizedWords;
          allTexts = _text.split(" ").toList();
          _stopListening();
        },
      );
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Audio to Sign Converter'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _isListening ? _stopListening : _startListening,
            backgroundColor: Colors.blue,
            child: Icon(_isListening ? Icons.mic_off : Icons.mic),
          ),
          const SizedBox(width: 12),
          Text(
            _isListening ? 'Stop \nSpeaking' : 'Start \nSpeaking',
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: allTexts.isEmpty
                ? Image.asset(
                    "assets/videos/intro.gif",
                    fit: BoxFit.fitHeight,
                  )
                : FutureBuilder(
                    future: Future.delayed(const Duration(milliseconds: 500)),
                    builder: (context, _) {
                      return Image.asset(
                        "assets/videos/clear.gif",
                        fit: BoxFit.fitHeight,
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),
          Positioned(
            top: 40,
            left: 40,
            right: 40,
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
