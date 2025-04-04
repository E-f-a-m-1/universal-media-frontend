import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(UniversalMediaApp());

class UniversalMediaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal Media Hub',
      theme: ThemeData.dark(),
      home: MediaListScreen(),
    );
  }
}

class MediaListScreen extends StatelessWidget {
  final List<Map<String, String>> mediaItems = [
    {
      'title': 'Epic Anime Episode 1',
      'url': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      'creator': 'Studio Bunny',
    },
    {
      'title': 'Indie Music Video',
      'url': 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      'creator': 'Indie Band',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Media List')),
      body: ListView.builder(
        itemCount: mediaItems.length,
        itemBuilder: (context, index) {
          final item = mediaItems[index];
          return ListTile(
            title: Text(item['title']!),
            subtitle: Text('By ${item['creator']}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaPlayerScreen(
                  title: item['title']!,
                  url: item['url']!,
                  creator: item['creator']!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MediaPlayerScreen extends StatefulWidget {
  final String title;
  final String url;
  final String creator;

  MediaPlayerScreen({required this.title, required this.url, required this.creator});

  @override
  _MediaPlayerScreenState createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _simulateDownload() {
    setState(() => _isDownloading = true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _isDownloading = false);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Download Complete'),
          content: Text('Video by ${widget.creator}. Please support original creators.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text('OK'))],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _controller.value.isInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                ElevatedButton(
                  onPressed: _isDownloading ? null : _simulateDownload,
                  child: Text(_isDownloading ? 'Downloading...' : 'Download'),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}