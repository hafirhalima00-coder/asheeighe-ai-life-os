import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../providers/quran_provider.dart';
import '../widgets/audio_player_controls.dart';

class QuranReaderScreen extends StatefulWidget {
  final int surahId;

  const QuranReaderScreen({super.key, required this.surahId});

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  bool _showEnglish = true;
  bool _showFrench = false;
  bool _showTransliteration = false;
  bool _isPlaying = false;
  String _selectedReciter = 'mishary';
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranNotifier>().loadAyahs(widget.surahId);
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _playAudio() {
    final quran = context.read<QuranNotifier>();
    final url = quran.getAudioUrl(widget.surahId);
    _audioPlayer?.play(UrlSource(url));
    setState(() => _isPlaying = true);
  }

  void _pauseAudio() {
    _audioPlayer?.pause();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: Consumer<QuranNotifier>(
          builder: (context, quran, child) {
            return Text(
              quran.currentSurah?.nameEnglish ?? '',
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _showEnglish = value == 'english' ? !_showEnglish : _showEnglish;
                _showFrench = value == 'french' ? !_showFrench : _showFrench;
                _showTransliteration = value == 'transliteration' ? !_showTransliteration : _showTransliteration;
              });
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'english',
                checked: _showEnglish,
                child: const Text('English Translation'),
              ),
              CheckedPopupMenuItem(
                value: 'french',
                checked: _showFrench,
                child: const Text('French Translation'),
              ),
              CheckedPopupMenuItem(
                value: 'transliteration',
                checked: _showTransliteration,
                child: const Text('Transliteration'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<QuranNotifier>(
        builder: (context, quran, child) {
          if (quran.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quran.currentAyahs.length,
                  itemBuilder: (context, index) {
                    final ayah = quran.currentAyahs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${ayah.numberInSurah}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.bookmark_border, size: 20),
                                onPressed: () {
                                  quran.bookmarkAyah(widget.surahId, ayah.numberInSurah);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            ayah.arabicText,
                            style: const TextStyle(
                              fontSize: 28,
                              height: 2.0,
                              fontFamily: 'Amiri',
                              color: Color(0xFF333333),
                            ),
                            textAlign: TextAlign.right,
                          ),
                          if (_showTransliteration) ...[
                            const SizedBox(height: 12),
                            Text(
                              ayah.transliteration,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                          if (_showEnglish) ...[
                            const SizedBox(height: 12),
                            Text(
                              ayah.englishTranslation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF555555),
                                height: 1.5,
                              ),
                            ),
                          ],
                          if (_showFrench) ...[
                            const SizedBox(height: 8),
                            Text(
                              ayah.frenchTranslation,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              AudioPlayerControls(
                isPlaying: _isPlaying,
                onPlay: _playAudio,
                onPause: _pauseAudio,
                selectedReciter: _selectedReciter,
                onReciterChanged: (reciter) {
                  setState(() => _selectedReciter = reciter);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
