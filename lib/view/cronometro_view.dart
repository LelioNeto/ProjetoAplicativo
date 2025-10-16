import 'dart:async';
import 'package:flutter/material.dart';

class CronometroView extends StatefulWidget {
  const CronometroView({super.key});

  @override
  State<CronometroView> createState() => _CronometroViewState();
}

class _CronometroViewState extends State<CronometroView> {
  static const _bg = Color(0xFF0F0F0F);
  static const _card = Color(0xFF1A1A1A);

  Timer? _timer;
  DateTime? _startedAt; // quando começou (ou retomou)
  Duration _elapsed = Duration.zero; // tempo acumulado
  bool _running = false; // está contando agora?
  bool _paused = false; // foi pausado e pode retomar?

  void _tick(_) => setState(() {});

  void _start() {
    if (_running) return;
    _startedAt = DateTime.now();
    _running = true;
    _paused = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), _tick);
    setState(() {});
  }

  void _pause() {
    if (!_running) return;
    _elapsed += DateTime.now().difference(_startedAt!);
    _running = false;
    _paused = true;
    _timer?.cancel();
    setState(() {});
  }

  void _resume() {
    if (!_paused) return;
    _startedAt = DateTime.now();
    _running = true;
    _paused = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), _tick);
    setState(() {});
  }

  /// Para a contagem e mantém o tempo atual (pode zerar depois).
  void _stop() {
    if (_running) {
      _elapsed += DateTime.now().difference(_startedAt!);
    }
    _running = false;
    _paused = false;
    _timer?.cancel();
    setState(() {});
  }

  /// Zera o cronômetro (se estiver rodando, continua a partir de zero).
  void _reset() {
    _elapsed = Duration.zero;
    if (_running) {
      _startedAt = DateTime.now();
    }
    setState(() {});
  }

  Duration get _current {
    if (_running && _startedAt != null) {
      return _elapsed + DateTime.now().difference(_startedAt!);
    }
    return _elapsed;
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = _fmt(_current);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _card,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Cronômetro', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Tempo',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  FittedBox(
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Linha 1: iniciar/pausar/retomar
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _running ? null : _start,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _running ? _pause : null,
                    icon: const Icon(Icons.pause, color: Colors.white),
                    label: const Text(
                      'Pausar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _paused ? _resume : null,
                    icon: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Retomar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Linha 2: parar/zerar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: (_running || _paused || _elapsed > Duration.zero)
                        ? _stop
                        : null,
                    icon: const Icon(Icons.stop, color: Colors.white),
                    label: const Text(
                      'Parar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_elapsed > Duration.zero || _running)
                        ? _reset
                        : null,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Zerar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
