import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balanco_game/features/game/components/game_background/pyramids_painter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BgConfigScreen – interactive background designer (dev tool)
// ─────────────────────────────────────────────────────────────────────────────

class BgConfigScreen extends StatefulWidget {
  const BgConfigScreen({super.key});

  @override
  State<BgConfigScreen> createState() => _BgConfigScreenState();
}

// ── Mutable pyramid position ──────────────────────────────────────────────────
class _PyramidState {
  double cx;
  double peakYF;
  double baseYF;
  double halfWF;
  final String label;

  _PyramidState({
    required this.cx,
    required this.peakYF,
    required this.baseYF,
    required this.halfWF,
    required this.label,
  });
}

// ── Layer entry ───────────────────────────────────────────────────────────────
class _LayerEntry {
  final String name;
  double depthMultiplier;
  bool visible;

  _LayerEntry({
    required this.name,
    required this.depthMultiplier,
    this.visible = true,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
class _BgConfigScreenState extends State<BgConfigScreen>
    with SingleTickerProviderStateMixin {
  // Canvas logical size
  static const double _cW = 1000;
  static const double _cH = 475;

  // ── View mode ───────────────────────────────────────────────────────────────
  bool _isMobileView = false;

  // ── Pyramid positions ───────────────────────────────────────────────────────
  final List<_PyramidState> _pyramids = [
    _PyramidState(
      cx: 0.3800,
      peakYF: 0.3167,
      baseYF: 0.7135,
      halfWF: 0.1624,
      label: 'Left',
    ),
    _PyramidState(
      cx: 0.5000,
      peakYF: 0.1800,
      baseYF: 0.7069,
      halfWF: 0.1842,
      label: 'Centre',
    ),
    _PyramidState(
      cx: 0.6303,
      peakYF: 0.2501,
      baseYF: 0.7901,
      halfWF: 0.1981,
      label: 'Right',
    ),
  ];
  int _selectedPyramid = 1;
  int? _draggingPyramid;

  // ── Pyramid colors ──────────────────────────────────────────────────────────
  Color _leftShadow = const Color(0xFF2A0E60);
  Color _leftMid = const Color(0xFF5B3AA8);
  Color _leftLight = const Color(0xFF9B7FDC);
  Color _rightLight = const Color(0xFFD0C0F8);
  Color _rightMid = const Color(0xFFAA90E8);
  Color _rightShadow = const Color(0xFF7B5CC0);
  Color _ridgeLine = const Color(0xFF1A0840);

  // ── Midground dunes ─────────────────────────────────────────────────────────
  Color _sandColor = const Color(0xFFF2C89A);
  Color _duneColor = const Color(0xFF6A2CA0);
  Color _camelColor = const Color(0xFF8B5E3C);
  double _sandTopF = 0.68;
  double _sandPeakF = 0.48;
  double _duneLeftTopF = 0.60;
  double _duneRightTopF = 0.55;
  bool _showCamels = true;

  // ── Foreground dunes ────────────────────────────────────────────────────────
  Color _fgColor = const Color(0xFF200E48);
  Color _crestColor = const Color(0xFFF2C89A);
  double _fgLeftHeightF = 0.80;
  double _fgRightHeightF = 0.75;
  double _fgCrestAlpha = 0.22;

  // ── Layer order ─────────────────────────────────────────────────────────────
  final List<_LayerEntry> _layers = [
    _LayerEntry(name: 'Sky', depthMultiplier: 0.0),
    _LayerEntry(name: 'Wispy Clouds', depthMultiplier: 0.1),
    _LayerEntry(name: 'Distant Mountains', depthMultiplier: 0.2),
    _LayerEntry(name: 'Main Pyramids', depthMultiplier: 0.4),
    _LayerEntry(name: 'Midground Dunes', depthMultiplier: 0.7),
    _LayerEntry(name: 'Foreground Dunes', depthMultiplier: 1.0),
  ];

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Live painter builders ────────────────────────────────────────────────────
  MainPyramidsPainter get _pyramidPainter => MainPyramidsPainter(
    left: PyramidConfig(
      cx: _pyramids[0].cx,
      peakYF: _pyramids[0].peakYF,
      baseYF: _pyramids[0].baseYF,
      halfWF: _pyramids[0].halfWF,
    ),
    centre: PyramidConfig(
      cx: _pyramids[1].cx,
      peakYF: _pyramids[1].peakYF,
      baseYF: _pyramids[1].baseYF,
      halfWF: _pyramids[1].halfWF,
    ),
    right: PyramidConfig(
      cx: _pyramids[2].cx,
      peakYF: _pyramids[2].peakYF,
      baseYF: _pyramids[2].baseYF,
      halfWF: _pyramids[2].halfWF,
    ),
    colors: PyramidColorConfig(
      leftShadow: _leftShadow,
      leftMid: _leftMid,
      leftLight: _leftLight,
      rightLight: _rightLight,
      rightMid: _rightMid,
      rightShadow: _rightShadow,
      ridgeLine: _ridgeLine,
    ),
  );

  MidgroundDunesPainter get _midDunePainter => MidgroundDunesPainter(
    config: MidgroundDunesConfig(
      sandColor: _sandColor,
      duneColor: _duneColor,
      camelColor: _camelColor,
      sandTopF: _sandTopF,
      sandPeakF: _sandPeakF,
      duneLeftTopF: _duneLeftTopF,
      duneRightTopF: _duneRightTopF,
      showCamels: _showCamels,
    ),
  );

  ForegroundDunesPainter get _fgDunePainter => ForegroundDunesPainter(
    config: ForegroundDunesConfig(
      fgColor: _fgColor,
      crestColor: _crestColor,
      leftHeightF: _fgLeftHeightF,
      rightHeightF: _fgRightHeightF,
      crestAlpha: _fgCrestAlpha,
    ),
  );

  // ── Generated code ────────────────────────────────────────────────────────────
  String _generateCode() {
    String c(Color col) =>
        'Color(0x${col.value.toRadixString(16).toUpperCase().padLeft(8, '0')})';
    String f(double v) => v.toStringAsFixed(4);

    return '''// ── Pyramid BG Config ─────────────────────────────────────
MainPyramidsPainter(
  left: const PyramidConfig(
    cx:     ${f(_pyramids[0].cx)},
    peakYF: ${f(_pyramids[0].peakYF)},
    baseYF: ${f(_pyramids[0].baseYF)},
    halfWF: ${f(_pyramids[0].halfWF)},
  ),
  centre: const PyramidConfig(
    cx:     ${f(_pyramids[1].cx)},
    peakYF: ${f(_pyramids[1].peakYF)},
    baseYF: ${f(_pyramids[1].baseYF)},
    halfWF: ${f(_pyramids[1].halfWF)},
  ),
  right: const PyramidConfig(
    cx:     ${f(_pyramids[2].cx)},
    peakYF: ${f(_pyramids[2].peakYF)},
    baseYF: ${f(_pyramids[2].baseYF)},
    halfWF: ${f(_pyramids[2].halfWF)},
  ),
  colors: const PyramidColorConfig(
    leftShadow:  ${c(_leftShadow)},
    leftMid:     ${c(_leftMid)},
    leftLight:   ${c(_leftLight)},
    rightLight:  ${c(_rightLight)},
    rightMid:    ${c(_rightMid)},
    rightShadow: ${c(_rightShadow)},
    ridgeLine:   ${c(_ridgeLine)},
  ),
)

// ── Midground Dunes Config ─────────────────────────────
MidgroundDunesPainter(config: MidgroundDunesConfig(
  sandColor:     ${c(_sandColor)},
  duneColor:     ${c(_duneColor)},
  camelColor:    ${c(_camelColor)},
  sandTopF:      ${f(_sandTopF)},
  sandPeakF:     ${f(_sandPeakF)},
  duneLeftTopF:  ${f(_duneLeftTopF)},
  duneRightTopF: ${f(_duneRightTopF)},
  showCamels:    $_showCamels,
))

// ── Foreground Dunes Config ────────────────────────────
ForegroundDunesPainter(config: ForegroundDunesConfig(
  fgColor:       ${c(_fgColor)},
  crestColor:    ${c(_crestColor)},
  leftHeightF:   ${f(_fgLeftHeightF)},
  rightHeightF:  ${f(_fgRightHeightF)},
  crestAlpha:    ${f(_fgCrestAlpha)},
))

// ── Layer order + depth multipliers ───────────────────────
${_layers.mapIndexed((i, l) => '// [${i + 1}] ${l.name}  depth: ${l.depthMultiplier.toStringAsFixed(2)}  visible: ${l.visible}').join('\n')}
''';
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generateCode()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Config copied!',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5B3AA8),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Drag handlers ────────────────────────────────────────────────────────────
  void _onPanStart(DragStartDetails d, double sx, double sy) {
    final lx = d.localPosition.dx / sx;
    final ly = d.localPosition.dy / sy;
    double best = 40;
    _draggingPyramid = null;
    for (int i = 0; i < _pyramids.length; i++) {
      final p = _pyramids[i];
      final dist =
          (Offset(lx, ly) - Offset(p.cx * _cW, p.peakYF * _cH)).distance;
      if (dist < best) {
        best = dist;
        _draggingPyramid = i;
      }
    }
    if (_draggingPyramid != null)
      setState(() => _selectedPyramid = _draggingPyramid!);
  }

  void _onPanUpdate(DragUpdateDetails d, double sx, double sy) {
    if (_draggingPyramid == null) return;
    setState(() {
      final p = _pyramids[_draggingPyramid!];
      p.cx = (p.cx + d.delta.dx / sx / _cW).clamp(0.05, 0.95);
      p.peakYF = (p.peakYF + d.delta.dy / sy / _cH).clamp(
        0.02,
        p.baseYF - 0.05,
      );
    });
  }

  void _onPanEnd(DragEndDetails _) => _draggingPyramid = null;

  // ── Colors ────────────────────────────────────────────────────────────────────
  static const Color _bg = Color(0xFF12082A);
  static const Color _surface = Color(0xFF1E1040);
  static const Color _accent = Color(0xFF7B5CC0);
  static const Color _accentL = Color(0xFFBBA8E8);

  // ─────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1850),
        elevation: 0,
        title: Text(
          '🎨 BG Config Editor',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          // ── Mobile / Canvas toggle ──────────────────────────────────────
          Tooltip(
            message: _isMobileView ? 'Canvas view' : 'Mobile view',
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => _isMobileView = !_isMobileView),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _isMobileView
                      ? _accent
                      : _accent.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _accentL.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isMobileView
                          ? Icons.phone_android
                          : Icons.desktop_windows,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _isMobileView ? 'Mobile' : 'Canvas',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ── Copy config ─────────────────────────────────────────────────
          TextButton.icon(
            onPressed: _copyToClipboard,
            icon: const Icon(Icons.copy, color: Colors.white, size: 16),
            label: Text(
              'Copy',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          if (isWide) {
            return Row(
              children: [
                Expanded(flex: 3, child: _buildPreviewArea()),
                Container(width: 1, color: _accent.withValues(alpha: 0.25)),
                SizedBox(width: 330, child: _buildSidePanel()),
              ],
            );
          } else {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.40,
                  child: _buildPreviewArea(),
                ),
                Expanded(child: _buildSidePanel()),
              ],
            );
          }
        },
      ),
    );
  }

  // ── Preview area ──────────────────────────────────────────────────────────────
  Widget _buildPreviewArea() {
    return Container(
      color: const Color(0xFF0C051A),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _isMobileView
                    ? '📱 Mobile preview — drag peaks to move pyramids'
                    : '🖥  Canvas preview — drag peaks to move pyramids',
                style: GoogleFonts.inter(color: _accentL, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: _isMobileView ? _buildMobileFrame() : _buildCanvasFrame(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Canvas frame (1000×475 landscape) ────────────────────────────────────────
  Widget _buildCanvasFrame() {
    return AspectRatio(
      aspectRatio: _cW / _cH,
      child: LayoutBuilder(
        builder: (context, box) {
          final sx = box.maxWidth / _cW;
          final sy = box.maxHeight / _cH;
          return GestureDetector(
            onPanStart: (d) => _onPanStart(d, sx, sy),
            onPanUpdate: (d) => _onPanUpdate(d, sx, sy),
            onPanEnd: _onPanEnd,
            child: Stack(
              children: [
                ..._buildVisibleLayers(sx, sy, false),
                ..._buildPyramidHandles(sx, sy),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Mobile frame (portrait phone ~9:19.5) ─────────────────────────────────────
  Widget _buildMobileFrame() {
    return LayoutBuilder(
      builder: (ctx, box) {
        const phoneAR = 9.0 / 19.5;
        final phoneH = box.maxHeight * 0.95;
        final phoneW = phoneH * phoneAR;
        final sx = phoneW / _cW;
        final sy = phoneH / _cH;

        return Center(
          child: GestureDetector(
            onPanStart: (d) => _onPanStart(d, sx, sy),
            onPanUpdate: (d) => _onPanUpdate(d, sx, sy),
            onPanEnd: _onPanEnd,
            child: Container(
              width: phoneW + 20,
              height: phoneH + 20,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A30),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(color: const Color(0xFF4A4A70), width: 10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: SizedBox(
                  width: phoneW,
                  height: phoneH,
                  child: Stack(
                    children: [
                      ..._buildVisibleLayers(sx, sy, true),
                      ..._buildPyramidHandles(sx, sy),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Build all visible layer painters ─────────────────────────────────────────
  List<Widget> _buildVisibleLayers(double sx, double sy, bool mobile) {
    final widgets = <Widget>[];
    for (final layer in _layers) {
      if (!layer.visible) continue;
      CustomPainter? painter;
      switch (layer.name) {
        case 'Sky':
          painter = PyramidSkyPainter();
          break;
        case 'Wispy Clouds':
          painter = WispyCloudPainter();
          break;
        case 'Distant Mountains':
          painter = DistantMountainsPainter();
          break;
        case 'Main Pyramids':
          painter = _pyramidPainter;
          break;
        case 'Midground Dunes':
          painter = _midDunePainter;
          break;
        case 'Foreground Dunes':
          painter = _fgDunePainter;
          break;
        default:
          continue;
      }
      if (mobile) {
        // In mobile mode use Positioned.fill so painters adapt to portrait size
        widgets.add(Positioned.fill(child: CustomPaint(painter: painter)));
      } else {
        // In canvas mode scale the 1000×475 painters to the displayed size
        widgets.add(
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _cW,
                height: _cH,
                child: CustomPaint(painter: painter),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  // ── Pyramid drag handles ──────────────────────────────────────────────────────
  List<Widget> _buildPyramidHandles(double sx, double sy) {
    final handles = <Widget>[];
    for (int i = 0; i < _pyramids.length; i++) {
      final p = _pyramids[i];
      final bool isSel = i == _selectedPyramid;
      final bool isDrag = i == _draggingPyramid;

      final double px = p.cx * _cW * sx;
      final double py = p.peakYF * _cH * sy;

      // Peak handle (drag to move)
      handles.add(
        Positioned(
          left: px - 14,
          top: py - 14,
          child: GestureDetector(
            onTap: () => setState(() => _selectedPyramid = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isDrag
                    ? Colors.white
                    : isSel
                    ? const Color(0xFF9B7FDC)
                    : _accent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B7FDC).withValues(alpha: 0.7),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  p.label[0],
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Width resize handle (right base edge)
      final double bx = (p.cx + p.halfWF) * _cW * sx;
      final double by = p.baseYF * _cH * sy;
      handles.add(
        Positioned(
          left: bx - 8,
          top: by - 8,
          child: GestureDetector(
            onPanUpdate: (d) => setState(
              () => p.halfWF = (p.halfWF + d.delta.dx / sx / _cW).clamp(
                0.04,
                0.45,
              ),
            ),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _accentL,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ),
      );

      // Base-Y resize handle (base centre)
      handles.add(
        Positioned(
          left: p.cx * _cW * sx - 8,
          top: by - 8,
          child: GestureDetector(
            onPanUpdate: (d) => setState(
              () => p.baseYF = (p.baseYF + d.delta.dy / sy / _cH).clamp(
                p.peakYF + 0.05,
                1.0,
              ),
            ),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ),
      );
    }
    return handles;
  }

  // ── Side panel ────────────────────────────────────────────────────────────────
  Widget _buildSidePanel() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: _accentL,
          indicatorColor: _accent,
          labelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Pyramids'),
            Tab(text: 'Dunes'),
            Tab(text: 'Colors'),
            Tab(text: 'Layers'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPyramidTab(),
              _buildDunesTab(),
              _buildColorsTab(),
              _buildLayersTab(),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TAB 1: Pyramids
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildPyramidTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Pyramid selector
        Row(
          children: List.generate(_pyramids.length, (i) {
            final bool sel = i == _selectedPyramid;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPyramid = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? _accent : _surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: sel ? _accentL : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _pyramids[i].label,
                      style: GoogleFonts.inter(
                        color: sel ? Colors.white : _accentL,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        _pyramidSliders(_pyramids[_selectedPyramid]),
        const SizedBox(height: 20),
        _codePreview(),
      ],
    );
  }

  Widget _pyramidSliders(_PyramidState p) => Column(
    children: [
      _slider(
        'Center X',
        p.cx,
        0.02,
        0.98,
        (v) => setState(() => p.cx = v),
        '%',
      ),
      _slider(
        'Peak Y (top)',
        p.peakYF,
        0.02,
        p.baseYF - 0.05,
        (v) => setState(() => p.peakYF = v),
        '%',
      ),
      _slider(
        'Base Y',
        p.baseYF,
        p.peakYF + 0.05,
        1.0,
        (v) => setState(() => p.baseYF = v),
        '%',
      ),
      _slider(
        'Half-Width',
        p.halfWF,
        0.04,
        0.45,
        (v) => setState(() => p.halfWF = v),
        '%',
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // TAB 2: Dunes
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildDunesTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _sectionHeader('Midground Dunes'),
        _slider(
          'Sand Left Edge Y',
          _sandTopF,
          0.30,
          0.90,
          (v) => setState(() => _sandTopF = v),
          '%',
        ),
        _slider(
          'Sand Arc Peak Y',
          _sandPeakF,
          0.20,
          0.80,
          (v) => setState(() => _sandPeakF = v),
          '%',
        ),
        _slider(
          'Left Dune Top Y',
          _duneLeftTopF,
          0.25,
          0.85,
          (v) => setState(() => _duneLeftTopF = v),
          '%',
        ),
        _slider(
          'Right Dune Top Y',
          _duneRightTopF,
          0.25,
          0.85,
          (v) => setState(() => _duneRightTopF = v),
          '%',
        ),
        _toggleRow(
          'Show Camels',
          _showCamels,
          (v) => setState(() => _showCamels = v),
        ),
        const SizedBox(height: 8),
        _colorRow(
          'Sand Color',
          _sandColor,
          (c) => setState(() => _sandColor = c),
        ),
        _colorRow(
          'Dune Color',
          _duneColor,
          (c) => setState(() => _duneColor = c),
        ),
        _colorRow(
          'Camel Color',
          _camelColor,
          (c) => setState(() => _camelColor = c),
        ),
        const SizedBox(height: 20),
        _sectionHeader('Foreground Dune'),
        _slider(
          'Left Height Y',
          _fgLeftHeightF,
          0.50,
          0.95,
          (v) => setState(() => _fgLeftHeightF = v),
          '%',
        ),
        _slider(
          'Right Height Y',
          _fgRightHeightF,
          0.50,
          0.95,
          (v) => setState(() => _fgRightHeightF = v),
          '%',
        ),
        _slider(
          'Crest Opacity',
          _fgCrestAlpha,
          0.00,
          1.00,
          (v) => setState(() => _fgCrestAlpha = v),
          '',
        ),
        _colorRow('FG Color', _fgColor, (c) => setState(() => _fgColor = c)),
        _colorRow(
          'Crest Color',
          _crestColor,
          (c) => setState(() => _crestColor = c),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TAB 3: Colors (pyramid face colors)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildColorsTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _sectionHeader('Left Face (Shadow Side)'),
        _colorRow(
          'Dark Edge',
          _leftShadow,
          (c) => setState(() => _leftShadow = c),
        ),
        _colorRow('Mid Tone', _leftMid, (c) => setState(() => _leftMid = c)),
        _colorRow(
          'Light Edge',
          _leftLight,
          (c) => setState(() => _leftLight = c),
        ),
        const SizedBox(height: 12),
        _sectionHeader('Right Face (Lit Side)'),
        _colorRow(
          'Light Edge',
          _rightLight,
          (c) => setState(() => _rightLight = c),
        ),
        _colorRow('Mid Tone', _rightMid, (c) => setState(() => _rightMid = c)),
        _colorRow(
          'Dark Edge',
          _rightShadow,
          (c) => setState(() => _rightShadow = c),
        ),
        const SizedBox(height: 12),
        _sectionHeader('Ridge'),
        _colorRow(
          'Ridge Line',
          _ridgeLine,
          (c) => setState(() => _ridgeLine = c),
        ),
        const SizedBox(height: 20),
        // Quick color presets
        _sectionHeader('Quick Presets'),
        _presetGrid(),
      ],
    );
  }

  Widget _presetGrid() {
    final presets = [
      (
        'Purple',
        const Color(0xFF2A0E60),
        const Color(0xFF9B7FDC),
        const Color(0xFFD0C0F8),
        const Color(0xFF7B5CC0),
      ),
      (
        'Blue',
        const Color(0xFF0A1A4A),
        const Color(0xFF3A6AB8),
        const Color(0xFFB0CCF8),
        const Color(0xFF3A6AB8),
      ),
      (
        'Teal',
        const Color(0xFF083030),
        const Color(0xFF208880),
        const Color(0xFFA0E8E0),
        const Color(0xFF208880),
      ),
      (
        'Rose',
        const Color(0xFF400818),
        const Color(0xFFA83060),
        const Color(0xFFF0B0C8),
        const Color(0xFFA83060),
      ),
      (
        'Gold',
        const Color(0xFF301800),
        const Color(0xFF906020),
        const Color(0xFFF8E080),
        const Color(0xFF906020),
      ),
      (
        'Crimson',
        const Color(0xFF2A0808),
        const Color(0xFF882020),
        const Color(0xFFF0A0A0),
        const Color(0xFF882020),
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((p) {
        return GestureDetector(
          onTap: () => setState(() {
            _leftShadow = p.$2;
            _leftMid = Color.lerp(p.$2, p.$3, 0.55)!;
            _leftLight = p.$3;
            _rightLight = p.$4;
            _rightMid = Color.lerp(p.$4, p.$5, 0.5)!;
            _rightShadow = p.$5;
          }),
          child: Container(
            width: 64,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(colors: [p.$2, p.$3, p.$4, p.$5]),
              border: Border.all(
                color: _accentL.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                p.$1,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  shadows: [const Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TAB 4: Layers
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildLayersTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            'Drag ☰ to reorder. Bottom = front (drawn last).',
            style: GoogleFonts.inter(color: _accentL, fontSize: 11),
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _layers.length,
            onReorder: (old, nw) {
              setState(() {
                if (nw > old) nw--;
                final item = _layers.removeAt(old);
                _layers.insert(nw, item);
              });
            },
            itemBuilder: (context, i) {
              final layer = _layers[i];
              return Container(
                key: ValueKey(layer.name),
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: layer.name == 'Main Pyramids'
                        ? _accent
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => layer.visible = !layer.visible),
                      child: Icon(
                        layer.visible ? Icons.visibility : Icons.visibility_off,
                        color: layer.visible ? _accentL : Colors.grey,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        layer.name,
                        style: GoogleFonts.inter(
                          color: layer.visible ? Colors.white : Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'depth: ${layer.depthMultiplier.toStringAsFixed(2)}',
                            style: GoogleFonts.robotoMono(
                              color: _accentL,
                              fontSize: 10,
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: _accent,
                              inactiveTrackColor: Colors.grey.shade800,
                              thumbColor: _accentL,
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                            ),
                            child: Slider(
                              value: layer.depthMultiplier,
                              min: 0.0,
                              max: 1.5,
                              onChanged: (v) =>
                                  setState(() => layer.depthMultiplier = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.drag_handle, color: Colors.grey, size: 18),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Shared UI helpers
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 4),
    child: Text(
      text.toUpperCase(),
      style: GoogleFonts.inter(
        color: _accent,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    String unit,
  ) {
    final display = unit == '%'
        ? '${(value * 100).round()}%'
        : value.toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: _accentL,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                display,
                style: GoogleFonts.robotoMono(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _accent,
              inactiveTrackColor: _surface,
              thumbColor: _accentL,
              overlayColor: _accent.withValues(alpha: 0.15),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: _accentL,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: _accent),
        ],
      ),
    );
  }

  /// Tappable color swatch row that opens the HSL color picker.
  Widget _colorRow(String label, Color color, ValueChanged<Color> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: _accentL,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showColorPicker(label, color, onChanged),
            child: Container(
              width: 44,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '#${color.value.toRadixString(16).toUpperCase().padLeft(8, '0').substring(2)}',
            style: GoogleFonts.robotoMono(color: _accentL, fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// Code preview box with a copy button.
  Widget _codePreview() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generated Code',
                style: GoogleFonts.inter(
                  color: _accentL,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: _copyToClipboard,
                child: Row(
                  children: [
                    const Icon(Icons.copy, color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      'Copy',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            _generateCode(),
            style: GoogleFonts.robotoMono(
              color: const Color(0xFFD4C8F0),
              fontSize: 9.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── HSL Color Picker ──────────────────────────────────────────────────────────
  void _showColorPicker(
    String label,
    Color current,
    ValueChanged<Color> onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ColorPickerSheet(
        label: label,
        color: current,
        onChanged: (c) {
          onChanged(c);
          setState(() {});
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HSL Color Picker Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _ColorPickerSheet extends StatefulWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;

  const _ColorPickerSheet({
    required this.label,
    required this.color,
    required this.onChanged,
  });

  @override
  State<_ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<_ColorPickerSheet> {
  late HSLColor _hsl;

  @override
  void initState() {
    super.initState();
    _hsl = HSLColor.fromColor(widget.color);
  }

  Color get _color => _hsl.toColor();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1040),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Large color preview
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _color.withValues(alpha: 0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${_color.value.toRadixString(16).toUpperCase().padLeft(8, '0').substring(2)}',
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFFBBA8E8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Hue slider
          _hslSlider(
            'Hue',
            _hsl.hue,
            0,
            360,
            (v) {
              _hsl = _hsl.withHue(v);
              widget.onChanged(_color);
            },
            gradient: LinearGradient(
              colors: List.generate(
                7,
                (i) => HSLColor.fromAHSL(1, i * 60.0, 1, 0.5).toColor(),
              ),
            ),
          ),
          // Saturation slider
          _hslSlider(
            'Saturation',
            _hsl.saturation,
            0,
            1,
            (v) {
              _hsl = _hsl.withSaturation(v);
              widget.onChanged(_color);
            },
            gradient: LinearGradient(
              colors: [
                HSLColor.fromAHSL(1, _hsl.hue, 0.0, _hsl.lightness).toColor(),
                HSLColor.fromAHSL(1, _hsl.hue, 1.0, _hsl.lightness).toColor(),
              ],
            ),
          ),
          // Lightness slider
          _hslSlider(
            'Lightness',
            _hsl.lightness,
            0,
            1,
            (v) {
              _hsl = _hsl.withLightness(v);
              widget.onChanged(_color);
            },
            gradient: LinearGradient(
              colors: [
                Colors.black,
                HSLColor.fromAHSL(1, _hsl.hue, _hsl.saturation, 0.5).toColor(),
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hslSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    required LinearGradient gradient,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFFBBA8E8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value.toStringAsFixed(2),
                style: GoogleFonts.robotoMono(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Gradient track
          Stack(
            children: [
              Container(
                height: 18,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 18,
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withValues(alpha: 0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                ),
                child: Slider(
                  value: value.clamp(min, max),
                  min: min,
                  max: max,
                  onChanged: (v) => setState(() => onChanged(v)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Extension helpers ─────────────────────────────────────────────────────────
extension _IndexedMap<T> on List<T> {
  Iterable<R> mapIndexed<R>(R Function(int i, T e) fn) sync* {
    for (int i = 0; i < length; i++) yield fn(i, this[i]);
  }
}
