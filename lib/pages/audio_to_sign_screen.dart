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

    if (available) {
      _speech.listen(
        localeId: "ar_SA", // Specify the locale for Arabic
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            switch (_text) {
              case "السلام":
                _image = "assets/videos/salam.gif";
                break;
              case "اشرح":
                _image = "assets/videos/explain.gif";
                break;
              case "الكويت":
                _image = "assets/videos/kwd.gif";
                break;
              case "اليوم":
                _image = "assets/videos/day.gif";
                break;
              case "تاريخ":
                _image = "assets/videos/date.gif";
                break;
              case "ماده":
                _image = "assets/videos/material.gif";
                break;
              case "موضوع":
                _image = "assets/videos/subject.gif";
                break;
              case "واضح":
                _image = "assets/videos/clear.gif";
                break;
              default:
                _image = "assets/videos/intro.gif";
            }
          });
        },
      );
      setState(() => _isListening = false);
    } else {
      _stopListening();
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
        title: const Text('Audio to Sign Converter'),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
      body: Column(
        children: [
          SizedBox(
            height: 600,
            child: Image.asset(
              _image,
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
