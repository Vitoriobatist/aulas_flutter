import 'dart:convert';

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
      title: 'Cachorro Aleatorio',
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
  String? _imageUrl;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomDog();
  }

  Future<void> _fetchRandomDog() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
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

      if (!mounted) return;

      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Nao foi possivel carregar a foto.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotos aleatórias de chorros bunitos'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageWidth = constraints.maxWidth.clamp(0.0, 520.0);
            final imageHeight = (constraints.maxHeight * 0.68).clamp(
              240.0,
              460.0,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildContent(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _isLoading ? null : _fetchRandomDog,
                        icon: const Icon(Icons.pets),
                        label: const Text('Buscar outra foto'),
                      ),
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

  Widget _buildContent() {
    if (_isLoading && _imageUrl == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _imageUrl == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    if (_imageUrl == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          _imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;

            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nao foi possivel exibir esta imagem.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        if (_isLoading)
          const ColoredBox(
            color: Color(0x66000000),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
