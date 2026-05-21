import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DogApp());
}

class DogApp extends StatelessWidget {
  const DogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chorros Bonitos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DogPhotoPage(),
    );
  }
}

class DogPhotoPage extends StatefulWidget {
  const DogPhotoPage({super.key});

  @override
  State<DogPhotoPage> createState() => _DogPhotoPageState();
}

class _DogPhotoPageState extends State<DogPhotoPage> {
  Uint8List? _dogImageBytes;
  String? _dogErrorMessage;
  bool _isDogLoading = false;

  Uint8List? _gifBytes;
  String? _gifErrorMessage;
  bool _isGifLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomDog();
    _fetchRandomDogGif();
  }

  Future<void> _fetchRandomDog() async {
    setState(() {
      _isDogLoading = true;
      _dogErrorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://dog.ceo/api/breeds/image/random'),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final imageUrl = data['message'] as String?;

      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception('Resposta invalida da API');
      }

      final imageBytes = await _downloadMedia(imageUrl);

      if (!mounted) return;

      setState(() {
        _dogImageBytes = imageBytes;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _dogErrorMessage = 'Nao foi possivel carregar a foto.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isDogLoading = false;
        });
      }
    }
  }

  Future<void> _fetchRandomDogGif() async {
    setState(() {
      _isGifLoading = true;
      _gifErrorMessage = null;
    });

    try {
      String? gifUrl;

      for (var attempt = 0; attempt < 12; attempt++) {
        final response = await http.get(Uri.parse('https://random.dog/woof.json'));

        if (response.statusCode != 200) {
          throw Exception('Erro ${response.statusCode}');
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final url = data['url'] as String?;

        if (url != null && url.toLowerCase().endsWith('.gif')) {
          gifUrl = url;
          break;
        }
      }

      if (gifUrl == null) {
        throw Exception('A API nao retornou um GIF.');
      }

      final gifBytes = await _downloadMedia(gifUrl);

      if (!mounted) return;

      setState(() {
        _gifBytes = gifBytes;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _gifErrorMessage = 'Nao foi possivel carregar o GIF.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGifLoading = false;
        });
      }
    }
  }

  Future<Uint8List> _downloadMedia(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: const {
        'Accept': 'image/*',
        'User-Agent': 'flutter-atv-4',
      },
    );

    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      throw Exception('Nao foi possivel baixar a midia.');
    }

    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chorros Bonitos'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;
            final cardHeight = (constraints.maxHeight * 0.66).clamp(240.0, 460.0);
            final panels = [
              _MediaPanel(
                title: 'Foto',
                bytes: _dogImageBytes,
                errorMessage: _dogErrorMessage,
                isLoading: _isDogLoading,
                buttonText: 'Buscar outra foto',
                icon: Icons.pets,
                onPressed: _fetchRandomDog,
                height: cardHeight,
              ),
              _MediaPanel(
                title: 'GIF',
                bytes: _gifBytes,
                errorMessage: _gifErrorMessage,
                isLoading: _isGifLoading,
                buttonText: 'Buscar outro GIF',
                icon: Icons.gif_box,
                onPressed: _fetchRandomDogGif,
                height: cardHeight,
              ),
            ];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: panels[0]),
                            const SizedBox(width: 16),
                            Expanded(child: panels[1]),
                          ],
                        )
                      : Column(
                          children: [
                            panels[0],
                            const SizedBox(height: 16),
                            panels[1],
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MediaPanel extends StatelessWidget {
  const _MediaPanel({
    required this.title,
    required this.bytes,
    required this.errorMessage,
    required this.isLoading,
    required this.buttonText,
    required this.icon,
    required this.onPressed,
    required this.height,
  });

  final String title;
  final Uint8List? bytes;
  final String? errorMessage;
  final bool isLoading;
  final String buttonText;
  final IconData icon;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildContent(context),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: Icon(icon),
          label: Text(buttonText),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading && bytes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && bytes == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    if (bytes == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(
          bytes!,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nao foi possivel exibir esta midia.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        if (isLoading)
          const ColoredBox(
            color: Color(0x66000000),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
