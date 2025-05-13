import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AudioToSignScreen extends StatefulWidget {
  const AudioToSignScreen({super.key});

  @override
  State<AudioToSignScreen> createState() => _AudioToSignScreenState();
}

// edit for old version of mac

class _AudioToSignScreenState extends State<AudioToSignScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  List<String> allTexts = [];
  int currentWordIndex = 0;
  String _currentImage = "assets/videos/intro.gif";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startListening() async {
    setState(() => _isListening = true);
    await _speech.initialize(
      onStatus: (status) => print("Status: $status"),
      onError: (error) => print("Error: $error"),
    );

    allTexts.clear();
    await _speech.listen(
      localeId: "ar_SA",
      onResult: (result) {
        _text = result.recognizedWords;
        allTexts = _text.split(" ");
        if (allTexts.isNotEmpty) {
          _startShowingWords();
        }
      },
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  void _startShowingWords() {
    currentWordIndex = 0;
    _timer?.cancel(); // Cancel any previous timer

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentWordIndex < allTexts.length) {
        setState(() {
          // Here you can map the word to corresponding image if needed
          switch (allTexts[currentWordIndex]) {
            case 'السلام':
              _currentImage = "assets/videos/salam.gif";
              break;
            case 'العفو':
              _currentImage = "assets/videos/you'reWelcome.gif";
              break;
            case 'عفوا':
              _currentImage = "assets/videos/you'reWelcome.gif";
              break;
            case 'اكتب':
              _currentImage = "assets/videos/write.gif";
              break;
            case 'امس':
              _currentImage = "assets/videos/yesterday.gif";
              break;
            case 'من متى':
              _currentImage = "assets/videos/when.gif";
              break;
            case 'شكرا':
              _currentImage = "assets/videos/tanks.gif";
              break;
            case 'بطن':
              _currentImage = "assets/videos/stomache.gif";
              break;
            case 'بطني':
              _currentImage = "assets/videos/stomache.gif";
              break;
            case 'بطنك':
              _currentImage = "assets/videos/stomache.gif";
              break;
            case 'يعورك':
              _currentImage = "assets/videos/painYou.gif";
              break;
            case 'يعورني':
              _currentImage = "assets/videos/pain.gif";
              break;
            case 'دواء':
              _currentImage = "assets/videos/medicine.gif";
              break;
            case 'انا راح':
              _currentImage = "assets/videos/Iwill.gif";
              break;
            case 'طبيب':
              _currentImage = "assets/videos/dr.gif";
              break;
            case 'عليكم':
              _currentImage = "assets/videos/alikom.gif";
              break;
            case 'واضح':
              _currentImage = "assets/videos/clear.gif";
              break;
            case 'اشرح':
              _currentImage = "assets/videos/explain.gif";
              break;
            case 'الكويت':
              _currentImage = "assets/videos/kwd.gif";
              break;
            case 'اليوم':
              _currentImage = "assets/videos/day.gif";
              break;
            case 'تاريخ':
              _currentImage = "assets/videos/date.gif";
              break;
            case 'ماده':
              _currentImage = "assets/videos/material.gif";
              break;
            case 'موضوع':
              _currentImage = "assets/videos/subject.gif";
              break;
            default:
              _currentImage = "assets/videos/intro.gif";
              break;
          }
        });
        currentWordIndex++;
      } else {
        timer.cancel();
        setState(() {
          _currentImage = "assets/videos/intro.gif"; // After finishing words
        });
      }
    });
    setState(() {
      _isListening = false;
    });
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
            child: Image.asset(
              _currentImage,
              fit: BoxFit.fitHeight,
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
