import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Cat extends StatefulWidget {
  @override
  _Cat createState() => _Cat();
}

class _Cat extends State<Cat> {
  late VideoPlayerController _controller;
  final url = Uri.parse('https://drive.google.com/uc?id=1BgUm22Fj5Iu4Tm9s1Trn0FD1kd2kxlOZ&export=download');

  // Developer information
  final Map<String, String> teamInfo = {
    "Benjamin Ortiz": "Full-Stack Developer\nhttps://github.com/benja0rtzzz",
    "Alberto Reyes": "Frontend Developer\nhttps://github.com/Alberto2708",
    "Ángel Esquivel": "Frontend Developerr\nhttps://github.com/btoSSnake",
    "Juan Ávalos": "Frontend Developer\nhttps://github.com/juanvaloss",
  };

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      url,
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showInfoCard(BuildContext context, String name, String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Text(
            info,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KITTTTYYYYYYYYYYY!'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Video Section
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : const CircularProgressIndicator(),
            ),
          ),
          // Text Section with Tappable Names
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center-align text
              children: [
                const Text(
                  'This app\'s backend was developed by',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _showInfoCard(context, "Benjamin Ortiz", teamInfo["Benjamin Ortiz"]!),
                  child: const Text(
                    'Benjamin Ortiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'This app\'s front-end was developed by',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _showInfoCard(context, "Benjamin Ortiz", teamInfo["Benjamin Ortiz"]!),
                  child: const Text(
                    'Benjamin Ortiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _showInfoCard(context, "Alberto Reyes", teamInfo["Alberto Reyes"]!),
                  child: const Text(
                    'Alberto Reyes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _showInfoCard(context, "Ángel Esquivel", teamInfo["Ángel Esquivel"]!),
                  child: const Text(
                    'Ángel Esquivel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _showInfoCard(context, "Juan Ávalos", teamInfo["Juan Ávalos"]!),
                  child: const Text(
                    'Juan Ávalos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}