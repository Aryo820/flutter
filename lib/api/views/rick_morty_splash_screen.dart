import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppkd_b6/api/views/list_character.dart';

/// Palet warna terpusat untuk splash screen.
class _SplashColors {
  const _SplashColors._();

  static const background = Color(0xFFFFFBEF); // Soft warm cream
  static const tealBlob = Color(0xFFCBECEF);
  static const orangeBlob = Color(0xFFFFE0C2);
  static const primaryOrange = Color(0xFFFF7A00);
  static const amber = Color(0xFFFFB800);
  static const darkPurple = Color(0xFF2F215C);
  static const grayText = Color(0xFF6B7280);
  static const lightGray = Color(0xFF9CA3AF);
  static const dashGray = Color(0xFFE5E7EB);
}

/// Durasi animasi terpusat.
class _SplashDurations {
  const _SplashDurations._();

  static const portalRotation = Duration(seconds: 6);
  static const dashedRotation = Duration(seconds: 10);
  static const progress = Duration(seconds: 4);
  static const pulse = Duration(milliseconds: 1500);
  static const fade = Duration(milliseconds: 800);
  static const phraseSwitch = Duration(milliseconds: 200);
}

class RickMortySplashScreen extends StatefulWidget {
  static const routeName = '/rick_morty_splash';
  const RickMortySplashScreen({super.key});

  @override
  State<RickMortySplashScreen> createState() => _RickMortySplashScreenState();
}

class _RickMortySplashScreenState extends State<RickMortySplashScreen>
    with TickerProviderStateMixin {
  static const _characterImageUrl =
      'https://images.prodia.to/uploads/635a646c-2f95-46aa-bd42-5f65342d4a20.png';

  late final AnimationController _portalRotationController;
  late final AnimationController _dashedRotationController;
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  static const List<String> _loadingPhrases = [
    "CONNECTING TO DIMENSION C-137...",
    "POWERING UP PORTAL GUN...",
    "SCANNING MULTIVERSE...",
    "ESTABLISHING LINK...",
    "SYNCHRONIZING DATABASE...",
  ];

  @override
  void initState() {
    super.initState();

    // Portal berputar terus-menerus.
    _portalRotationController = AnimationController(
      duration: _SplashDurations.portalRotation,
      vsync: this,
    )..repeat();

    // Lingkaran putus-putus berputar lambat terus-menerus.
    _dashedRotationController = AnimationController(
      duration: _SplashDurations.dashedRotation,
      vsync: this,
    )..repeat();

    // Progress bar utama yang memicu navigasi saat selesai.
    _progressController = AnimationController(
      duration: _SplashDurations.progress,
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    )..addListener(() => setState(() {}));
    _progressController.addStatusListener(_onProgressStatusChanged);

    // Pulse pada gambar karakter.
    _pulseController = AnimationController(
      duration: _SplashDurations.pulse,
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade-in global.
    _fadeController = AnimationController(
      duration: _SplashDurations.fade,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
    _progressController.forward();
  }

  void _onProgressStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      Navigator.pushReplacementNamed(context, ListCharacter.routeName);
    }
  }

  @override
  void dispose() {
    _portalRotationController.dispose();
    _dashedRotationController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  int get _phraseIndex {
    final index = (_progressAnimation.value * _loadingPhrases.length).floor();
    return index.clamp(0, _loadingPhrases.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _SplashColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Blob teal lembut di kiri-atas.
            _buildBlob(
              top: -100,
              left: -100,
              diameter: 320,
              color: _SplashColors.tealBlob,
              maxOpacity: 0.6,
            ),
            // Blob orange lembut di kanan-tengah.
            _buildBlob(
              top: size.height * 0.35,
              right: -120,
              diameter: 350,
              color: _SplashColors.orangeBlob,
              maxOpacity: 0.5,
            ),
            _buildMainLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlob({
    double? top,
    double? left,
    double? right,
    required double diameter,
    required Color color,
    required double maxOpacity,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: maxOpacity),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainLayout() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),
                      _buildArtworkCard(constraints),
                      const SizedBox(height: 32),
                      _buildTypographyCard(),
                      const Spacer(flex: 2),
                      _buildProgressIndicator(),
                      const SizedBox(height: 16),
                      _buildLoadingPhrase(),
                      const Spacer(flex: 1),
                      _buildVersionLabel(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtworkCard(BoxConstraints constraints) {
    final cardSize = math.min(constraints.maxWidth * 0.8, 300.0);
    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Portal orange yang berputar.
            AnimatedBuilder(
              animation: _portalRotationController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, double.infinity),
                  painter: PortalPainter(
                    rotationValue: _portalRotationController.value,
                  ),
                );
              },
            ),
            // Gambar karakter dengan efek pulse.
            ScaleTransition(
              scale: _pulseAnimation,
              child: Image.network(
                _characterImageUrl,
                width: 140,
                height: 140,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.blur_circular,
                    size: 80,
                    color: _SplashColors.primaryOrange,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographyCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Rick & Morty ',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _SplashColors.darkPurple,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'Explorer',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _SplashColors.primaryOrange,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your high-end guide to the multiverse.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _SplashColors.grayText,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Lingkaran putus-putus yang berputar sebagai latar.
        RotationTransition(
          turns: _dashedRotationController,
          child: CustomPaint(
            size: const Size(64, 64),
            painter: DashedCirclePainter(
              color: _SplashColors.dashGray,
              strokeWidth: 2,
              dashes: 18,
              gapSize: 4,
            ),
          ),
        ),
        // Arc progress yang terisi.
        SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            value: _progressAnimation.value,
            strokeWidth: 3,
            valueColor: const AlwaysStoppedAnimation<Color>(
              _SplashColors.primaryOrange,
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
        // Ikon roket.
        const Icon(
          Icons.rocket_launch_rounded,
          size: 26,
          color: _SplashColors.darkPurple,
        ),
      ],
    );
  }

  Widget _buildLoadingPhrase() {
    final currentPhrase = _loadingPhrases[_phraseIndex];
    return AnimatedSwitcher(
      duration: _SplashDurations.phraseSwitch,
      child: Text(
        currentPhrase,
        key: ValueKey<String>(currentPhrase),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _SplashColors.lightGray,
          letterSpacing: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildVersionLabel() {
    return Text(
      'v1.1.0 • Stitch Edition',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: _SplashColors.lightGray,
        letterSpacing: 0.5,
      ),
    );
  }
}

// Dashed Circle Painter
class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashes;
  final double gapSize;

  DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    this.dashes = 20,
    this.gapSize = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double circumference = 2 * math.pi * radius;
    final double dashLength = (circumference / dashes) - gapSize;
    final double dashAngle = dashLength / radius;
    final double gapAngle = gapSize / radius;
    final rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    double startAngle = 0.0;
    for (int i = 0; i < dashes; i++) {
      canvas.drawArc(rect, startAngle, dashAngle, false, paint);
      startAngle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashes != dashes ||
        oldDelegate.gapSize != gapSize;
  }
}

// Swirling Portal Painter
class PortalPainter extends CustomPainter {
  final double rotationValue;

  PortalPainter({required this.rotationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Latar gradient radial untuk efek glow portal.
    final Paint glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          _SplashColors.amber.withValues(alpha: 0.55),
          _SplashColors.primaryOrange.withValues(alpha: 0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));
    canvas.drawCircle(center, maxRadius * 0.9, glowPaint);

    // Cincin batas luar.
    final Paint outerPaint = Paint()
      ..color = _SplashColors.primaryOrange.withValues(alpha: 0.7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, maxRadius * 0.92, outerPaint);

    // Swirl searah jarum jam.
    final Paint paintSwirlCW = Paint()
      ..color = _SplashColors.amber.withValues(alpha: 0.5)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Swirl berlawanan arah jarum jam.
    final Paint paintSwirlCCW = Paint()
      ..color = _SplashColors.primaryOrange.withValues(alpha: 0.35)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      final pathCW = Path();
      final pathCCW = Path();
      final double angleOffsetCW = i * (math.pi / 3) + rotationValue * 2 * math.pi;
      final double angleOffsetCCW = i * (math.pi / 3) - rotationValue * 2 * math.pi;

      pathCW.moveTo(center.dx, center.dy);
      pathCCW.moveTo(center.dx, center.dy);

      for (double theta = 0; theta < 2 * math.pi; theta += 0.1) {
        final double r = (maxRadius * 0.88 / (2 * math.pi)) * theta;
        final double x1 = center.dx + r * math.cos(theta + angleOffsetCW);
        final double y1 = center.dy + r * math.sin(theta + angleOffsetCW);

        final double x2 = center.dx + r * math.cos(theta + angleOffsetCCW);
        final double y2 = center.dy + r * math.sin(theta + angleOffsetCCW);

        if (theta == 0) {
          pathCW.moveTo(x1, y1);
          pathCCW.moveTo(x2, y2);
        } else {
          pathCW.lineTo(x1, y1);
          pathCCW.lineTo(x2, y2);
        }
      }
      canvas.drawPath(pathCW, paintSwirlCW);
      canvas.drawPath(pathCCW, paintSwirlCCW);
    }
  }

  @override
  bool shouldRepaint(covariant PortalPainter oldDelegate) {
    return oldDelegate.rotationValue != rotationValue;
  }
}
