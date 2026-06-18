import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/ble/notification_state_provider.dart';
import '../../../core/network/skapp_peer_target.dart';
import '../../../core/storage/paired_devices_store.dart';
import '../../../core/theme/colors.dart';
import '../../../l10n/app_localizations.dart';
import 'desktop_device_card.dart';
import 'device_card.dart';
import 'mobile_device_card.dart';

/// Cihazlarım takımyıldız görünümü · 3 dashed mustard halka, breath halo,
/// merkez hub ve hub etrafında organik pozisyonlanmış cihaz kartları.
///
/// `devices` boş ise empty state çizilir: halkalar opaklaştırılır, hub
/// "cihaz bekliyor" der, sağda hayalet (dashed) bir cihaz gösterilir,
/// merkez altta mustard "İlk Cihazı Ekle" CTA + sol-altta hint çipi.
class ConstellationView extends ConsumerStatefulWidget {
  const ConstellationView({
    super.key,
    required this.devices,
    required this.hubLabel,
    required this.onDeviceTap,
    required this.onAddTap,
    this.onDeviceLongPress,
    this.desktopPeers = const [],
    this.onDesktopPeerTap,
    this.onDesktopPeerLongPress,
    this.compact = false,
  });

  final List<PairedDevice> devices;
  final String hubLabel;
  final ValueChanged<PairedDevice> onDeviceTap;
  final VoidCallback onAddTap;
  /// Optional long-press handler for cards. DevicesScreen wires this to a
  /// "manage / forget" sheet so an offline BF can be removed without a
  /// live link. Null disables the gesture (no-op InkWell).
  final ValueChanged<PairedDevice>? onDeviceLongPress;

  /// Paired Desktop SKAPP peers (mobil sürümde). Mobile→desktop yönündeki
  /// eşleşme [skappPeersProvider] içinde durur, [pairedDevicesProvider]'a
  /// yazılmaz; bu yüzden ayrı liste alıp constellation'a aynı orbit'te
  /// yerleştirilir.
  final List<SkappPeerTarget> desktopPeers;

  /// Desktop peer kartına tıklandığında. Parent "SKAPI komutu gönderilsin
  /// mi?" onay dialogu açar; onaylanırsa emitEvent ile tetikleme yapar.
  final ValueChanged<SkappPeerTarget>? onDesktopPeerTap;

  /// Desktop peer kartına uzun basıldığında. Parent eşleşme kaldırma
  /// onayını açar (skappPeersProvider.remove).
  final ValueChanged<SkappPeerTarget>? onDesktopPeerLongPress;

  final bool compact;

  @override
  ConsumerState<ConstellationView> createState() => _ConstellationViewState();
}

class _ConstellationViewState extends ConsumerState<ConstellationView>
    with TickerProviderStateMixin {
  late final AnimationController _r1;
  late final AnimationController _r2;
  late final AnimationController _r3;
  late final AnimationController _halo;

  /// Kart yörünge animasyonu için ayrı controller. Frame'leri (60fps) tetikler;
  /// asıl hareket ve çarpışma mantığı [_orbits] map'inde tutulur, [_onOrbitTick]
  /// her tick'te açıları ve cooldown'ları günceller, AABB çarpışma testlerini
  /// yapar. Controller'ın değeri kullanılmaz — sadece her frame'de listener
  /// tetiklesin diye repeat() halinde tutulur.
  late final AnimationController _cardOrbit;

  /// Her cihaz (tile) için bağımsız yörünge durumu. Anahtar tile key
  /// ([_tileKey]); böylece cihaz listesi değişse bile mevcut kartların
  /// momentum'u (açı, yön) korunur.
  final Map<String, _CardOrbitState> _orbits = {};

  /// Önceki tick zamanı — frame'ler arası dt hesabı için. Null ise ilk
  /// tick atlanır.
  DateTime? _lastTickAt;

  /// Yörünge yarıçapları (px), tile başına benzersiz. İlk eklenen cihaz
  /// en içteki yörüngeyi alır; geri kalanlar dışa doğru sıralanır.
  static const List<double> _compactRadii = [55, 80, 105, 125, 145];
  static const List<double> _desktopRadii = [105, 155, 205, 250, 295];

  /// Her kart için tam tur süresi (saniye). 120 ile 180 arasında dağıtılır;
  /// farklı hızlar çarpışmaları doğal kılar. Tüm kartlar saat yönünde başlar.
  static const List<double> _periodsSeconds = [120, 145, 165, 130, 180];

  /// Çarpışma sonrası ping-pong önlemek için cooldown (ms).
  static const int _collisionCooldownMs = 600;

  @override
  void initState() {
    super.initState();
    _r1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
    )..repeat();
    _r2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 140),
    )..repeat(reverse: false);
    _r3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 200),
    )..repeat();
    _halo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    // Tick driver: 1sn periyot, sadece frame tetiklesin diye repeat().
    // Asıl hareket [_orbits] üzerinden DateTime delta ile hesaplanır.
    _cardOrbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(_onOrbitTick)
      ..repeat();
  }

  @override
  void dispose() {
    _r1.dispose();
    _r2.dispose();
    _r3.dispose();
    _halo.dispose();
    _cardOrbit
      ..removeListener(_onOrbitTick)
      ..dispose();
    super.dispose();
  }

  /// Her frame: tüm yörüngeleri ilerlet, cooldown'ları düşür, çarpışmaları
  /// AABB ile tespit edip iki kartın da yönünü ters çevir. AnimatedBuilder
  /// aynı controller'a abone olduğundan setState gerekmez; mutate edilen
  /// state bir sonraki rebuild'de okunur.
  void _onOrbitTick() {
    final now = DateTime.now();
    double dt = 0;
    if (_lastTickAt != null) {
      dt = now.difference(_lastTickAt!).inMicroseconds / 1e6;
    }
    _lastTickAt = now;
    // Uzun pause sonrası büyük dt'yi sıkıştır (örn. uygulama arka plana
    // gidip geri dönerse kartların dünyayı turlamasını engelle).
    if (dt > 0.1) dt = 0.1;
    if (dt <= 0 || _orbits.isEmpty) return;

    // 1) Açı + cooldown güncelle
    for (final o in _orbits.values) {
      o.angle += o.direction * o.angularSpeed * dt;
      if (o.cooldownMs > 0) {
        o.cooldownMs = math.max(0, o.cooldownMs - (dt * 1000).round());
      }
    }

    // 2) AABB çarpışma testi (pair-wise, en fazla 10 çift için yeterli)
    final keys = _orbits.keys.toList(growable: false);
    for (int i = 0; i < keys.length; i++) {
      final a = _orbits[keys[i]];
      if (a == null) continue;
      for (int j = i + 1; j < keys.length; j++) {
        final b = _orbits[keys[j]];
        if (b == null) continue;
        if (a.cooldownMs > 0 || b.cooldownMs > 0) continue;

        final ax = a.radius * math.cos(a.angle);
        final ay = a.radius * math.sin(a.angle);
        final bx = b.radius * math.cos(b.angle);
        final by = b.radius * math.sin(b.angle);

        final dx = (ax - bx).abs();
        final dy = (ay - by).abs();
        final wThresh = (a.cardSize.width + b.cardSize.width) / 2;
        final hThresh = (a.cardSize.height + b.cardSize.height) / 2;

        if (dx < wThresh && dy < hThresh) {
          a.direction = -a.direction;
          b.direction = -b.direction;
          a.cooldownMs = _collisionCooldownMs;
          b.cooldownMs = _collisionCooldownMs;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;
    // Constellation içerik boş mu: SK cihazları + desktop peer'ları birlikte
    // değerlendirilir. Mobil sürümde sadece desktop'lar paired olabilir, o
    // durumda da empty değil.
    final tileCount = widget.devices.length + widget.desktopPeers.length;
    final isEmpty = tileCount == 0;

    // Halka boyutları küçültüldü (~%22 azaltıldı): kartlar dar ekranlarda
    // dönerken viewport dışına taşıyordu. Halka çapı + kart yörüngesi
    // birlikte daraltıldı, böylece geometri kendi başına viewport'a sığar.
    final r1Size = compact ? 100.0 : 160.0;
    final r2Size = compact ? 160.0 : 300.0;
    final r3Size = compact ? 220.0 : 440.0;
    final haloSize = compact ? 90.0 : 140.0;

    // Halka opacity: empty state'te .45, normalde .40
    final ringOpacity = isEmpty ? 0.45 : 0.40;
    final ringStroke = isEmpty
        ? SkColors.attentionMustard.withValues(alpha: 0.30)
        : SkColors.attentionMustard.withValues(alpha: ringOpacity);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Halkalar — merkez (50%, 46%)
            _Ring(
              controller: _r3,
              size: r3Size,
              strokeColor: ringStroke,
              center: Alignment(0, _centerAlignY(compact)),
            ),
            _Ring(
              controller: _r2,
              size: r2Size,
              strokeColor: ringStroke,
              reverse: true,
              center: Alignment(0, _centerAlignY(compact)),
            ),
            _Ring(
              controller: _r1,
              size: r1Size,
              strokeColor: ringStroke,
              center: Alignment(0, _centerAlignY(compact)),
            ),

            // Halo
            Align(
              alignment: Alignment(0, _centerAlignY(compact)),
              child: _Halo(controller: _halo, size: haloSize, dimmed: isEmpty),
            ),

            // Hub
            Align(
              alignment: Alignment(0, _centerAlignY(compact)),
              child: _Hub(
                label: widget.hubLabel,
                subtitle: isEmpty
                    ? AppLocalizations.of(context).devicesHubEmptySubtitle
                    : AppLocalizations.of(context)
                        .devicesHubSubtitle(tileCount),
                compact: compact,
                dimmed: isEmpty,
              ),
            ),

            // Cihaz kartları (max 5) veya empty ghost
            if (!isEmpty)
              ..._positionedDeviceCards(w, h, compact)
            else
              _GhostDeviceCard(
                width: w,
                height: h,
                compact: compact,
              ),

            // Empty state CTA
            if (isEmpty)
              Positioned(
                left: 0,
                right: 0,
                top: h * 0.46 + (compact ? 70 : 100),
                child: Center(
                  child: _AddCta(onTap: widget.onAddTap),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Merkez pozisyonu Stack alignment Y'sinde. 46% top → align Y =
  /// (0.46 * 2) - 1 = -0.08
  double _centerAlignY(bool compact) => -0.08;

  /// Yerleşim için SK cihazları ile desktop peer'ları tek bir tile dizisi
  /// olarak birleştirir. Sıralama: önce paired SK cihazları (insertion
  /// order, ki SK kartları takımyıldızın öncelikli içeriği), sonra desktop
  /// peer'ları. Pozisyon dizileri (desktop 5, mobile 5) tile sayısını
  /// limitler; bu sınırın üstündeki tile'lar şu an gösterilmez.
  List<Object> get _tiles =>
      <Object>[...widget.devices, ...widget.desktopPeers];

  /// Konstelasyon kart yerleşimi: her cihaz kendi yarıçaplı, dairesel
  /// yörüngede saat yönünde döner. Açılar [_orbits] map'inde tutulur ve
  /// [_onOrbitTick] her frame'de hem ilerletir hem çarpışma kontrolü yapar.
  /// Burada sadece anlık konumu okuyup [Transform.translate] ile resmederiz.
  List<Widget> _positionedDeviceCards(double w, double h, bool compact) {
    final tiles = _tiles;
    final radii = compact ? _compactRadii : _desktopRadii;
    final maxCount = math.min(tiles.length, radii.length);
    if (maxCount == 0) return const [];

    final activeTiles = tiles.take(maxCount).toList();
    _syncOrbits(activeTiles, compact);

    final centerX = w * 0.50;
    final centerY = h * 0.46;
    final list = <Widget>[];

    for (final tile in activeTiles) {
      final key = _tileKey(tile);
      final orbit = _orbits[key];
      if (orbit == null) continue;

      final cardW = orbit.cardSize.width;
      final cardH = orbit.cardSize.height;
      // Positioned, merkez (hub) noktasında durur; gerçek hareket
      // Transform.translate ile yapılır.
      final baseLeft = centerX - cardW / 2;
      final baseTop = centerY - cardH / 2;

      list.add(Positioned(
        key: ValueKey('orbit-$key'),
        left: baseLeft,
        top: baseTop,
        child: AnimatedBuilder(
          animation: _cardOrbit,
          builder: (context, child) {
            final o = _orbits[key];
            if (o == null) return const SizedBox.shrink();
            final dx = o.radius * math.cos(o.angle);
            final dy = o.radius * math.sin(o.angle);
            return Transform.translate(
              offset: Offset(dx, dy),
              child: child,
            );
          },
          child: _buildOrbitingCardFromTile(tile, compact),
        ),
      ));
    }
    return list;
  }

  /// Cihaz listesi değiştiğinde yörünge map'ini eşitle: yeni cihazlara
  /// boş bir yarıçap slotu (ilk uygun) ata, gitmiş cihazların state'ini
  /// temizle. Mevcut kartların açı/yön momentum'u korunur.
  void _syncOrbits(List<Object> tiles, bool compact) {
    final radii = compact ? _compactRadii : _desktopRadii;
    final currentKeys = tiles.map(_tileKey).toSet();

    _orbits.removeWhere((k, _) => !currentKeys.contains(k));

    final usedRadii = _orbits.values.map((o) => o.radius).toSet();
    int slotIdx = 0;

    for (int i = 0; i < tiles.length; i++) {
      final tile = tiles[i];
      final key = _tileKey(tile);
      final existing = _orbits[key];
      if (existing != null) {
        // Compact↔desktop geçişinde kart boyutu değişebilir; güncel tut.
        final freshSize = _cardSizeForTile(tile, compact);
        if (existing.cardSize != freshSize) {
          existing.cardSize = freshSize;
        }
        continue;
      }

      // İlk boş yarıçap slot'unu bul.
      while (slotIdx < radii.length && usedRadii.contains(radii[slotIdx])) {
        slotIdx++;
      }
      if (slotIdx >= radii.length) break;

      final radius = radii[slotIdx];
      final period = _periodsSeconds[slotIdx % _periodsSeconds.length];
      // Saat yönü: Flutter ekran koord'ında Y aşağı pozitif, dolayısıyla
      // (cos θ, sin θ) ile θ artarken görsel olarak saat yönünde döneriz.
      // Başlangıç açıları beşli eşit dağıtım, hub'ın üstünden başlar.
      final startAngle = (i * 2 * math.pi / 5) - math.pi / 2;

      _orbits[key] = _CardOrbitState(
        radius: radius,
        angle: startAngle,
        direction: 1,
        angularSpeed: 2 * math.pi / period,
        cardSize: _cardSizeForTile(tile, compact),
        cooldownMs: 0,
      );
      usedRadii.add(radius);
      slotIdx++;
    }
  }

  /// Tile tipine göre kart bounding box'ı. Çarpışma testi gerçek görsel
  /// boyutları üzerinden yapılır.
  Size _cardSizeForTile(Object tile, bool compact) {
    if (tile is PairedDevice && tile.isMobilePeer) {
      return compact ? const Size(110, 80) : const Size(118, 94);
    }
    if (tile is SkappPeerTarget) {
      return compact ? const Size(110, 80) : const Size(118, 94);
    }
    // SK device — Strip card
    return compact ? const Size(132, 54) : const Size(152, 62);
  }

  String _tileKey(Object tile) {
    if (tile is PairedDevice) return 'dev-${tile.id}';
    if (tile is SkappPeerTarget) return 'peer-${tile.uuid}';
    return 'tile-${tile.hashCode}';
  }

  /// Tile tipine göre ilgili kart widget'ını döner ve slide-in/scale-in
  /// animasyonuyla sarar.
  Widget _buildOrbitingCardFromTile(Object tile, bool compact) {
    if (tile is SkappPeerTarget) {
      return _buildOrbitingDesktopPeerCard(tile, compact);
    }
    return _buildOrbitingCard(tile as PairedDevice, compact);
  }

  /// Slide-in/scale-in + Riverpod Consumer wrapper, both desktop ve
  /// mobile için ortak. ValueKey [Positioned] üzerinde olduğundan yeni
  /// cihaz eklendiğinde TweenAnimationBuilder otomatik 0→1 anim başlatır.
  Widget _buildOrbitingCard(PairedDevice d, bool compact) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.6 + 0.4 * t,
            child: child,
          ),
        );
      },
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(deviceNotificationStateProvider(d.id));
          final onLongPress = widget.onDeviceLongPress;
          // Mobile peer (prefix MS): SK kartı yerine MobileDeviceCard.
          // Normal tıklamada detay sayfası açılmaz; çağıran taraf bir
          // ipucu balonu gösterir (devices_screen.dart -> _onDeviceTap
          // mobil cihaz için SnackBar ile yanıtlar). Uzun bas eşleşmeyi
          // kaldırma onayına ulaşır. notificationState burada
          // okunmaz çünkü mobil kart şu an online/offline ayrımı
          // göstermiyor (gerçek online tespit altyapısı yok).
          if (d.isMobilePeer) {
            return MobileDeviceCard(
              device: d,
              onTapHint: () => widget.onDeviceTap(d),
              onLongPress:
                  onLongPress == null ? null : () => onLongPress(d),
              compact: compact,
            );
          }
          return ConstellationDeviceCard(
            device: d,
            notificationState: state,
            onTap: () => widget.onDeviceTap(d),
            onLongPress:
                onLongPress == null ? null : () => onLongPress(d),
            compact: compact,
          );
        },
      ),
    );
  }

  /// Desktop peer kartı (mobil sürümde Cihazlarım'da görünür). Tap →
  /// trigger popup, long-press → unpair confirm. Callback'ler null ise
  /// (örn. desktop sürüm) gesture etkisiz.
  Widget _buildOrbitingDesktopPeerCard(SkappPeerTarget peer, bool compact) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.6 + 0.4 * t,
            child: child,
          ),
        );
      },
      child: DesktopDeviceCard(
        peer: peer,
        onTapTrigger: () => widget.onDesktopPeerTap?.call(peer),
        onLongPress: widget.onDesktopPeerLongPress == null
            ? null
            : () => widget.onDesktopPeerLongPress!(peer),
        compact: compact,
      ),
    );
  }

}

/// Tek bir kartın yörünge durumu. Açı radian cinsinden, [direction] +1
/// saat yönü / -1 ters yön. [cooldownMs] çarpışma sonrası ping-pong'u
/// engellemek için sayaç (ms cinsinden).
class _CardOrbitState {
  _CardOrbitState({
    required this.radius,
    required this.angle,
    required this.direction,
    required this.angularSpeed,
    required this.cardSize,
    required this.cooldownMs,
  });

  final double radius;
  double angle;
  int direction;
  final double angularSpeed;
  Size cardSize;
  int cooldownMs;
}

class _Ring extends StatelessWidget {
  const _Ring({
    required this.controller,
    required this.size,
    required this.strokeColor,
    required this.center,
    this.reverse = false,
  });

  final AnimationController controller;
  final double size;
  final Color strokeColor;
  final Alignment center;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: center,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final t = controller.value * (reverse ? -1 : 1);
          return Transform.rotate(
            angle: t * 2 * math.pi,
            child: child,
          );
        },
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DashedRingPainter(color: strokeColor),
          ),
        ),
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  _DashedRingPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2 - 0.5;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    // Path ile dashed çember (PathMetrics)
    final path = Path()..addOval(Rect.fromCircle(center: center, radius: r));
    final metrics = path.computeMetrics().toList();
    const dash = 6.0;
    const gap = 6.0;
    for (final m in metrics) {
      double dist = 0;
      while (dist < m.length) {
        final next = math.min(dist + dash, m.length);
        canvas.drawPath(m.extractPath(dist, next), paint);
        dist = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _Halo extends StatelessWidget {
  const _Halo({
    required this.controller,
    required this.size,
    required this.dimmed,
  });

  final AnimationController controller;
  final double size;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // breath: 1.0..1.08 scale, 0.7..1.0 opacity
        final t = controller.value;
        final scale = 1.0 + 0.08 * t;
        final base = dimmed ? 0.55 : 1.0;
        final opacity = (0.7 + 0.3 * t) * base;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    SkColors.attentionMustard.withValues(alpha: 0.30),
                    SkColors.attentionMustard.withValues(alpha: 0.08),
                    SkColors.attentionMustard.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.5, 0.75],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Hub extends StatelessWidget {
  const _Hub({
    required this.label,
    required this.subtitle,
    required this.compact,
    required this.dimmed,
  });

  final String label;
  final String subtitle;
  final bool compact;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 38.0 : 56.0;
    final subSize = compact ? 8.5 : 10.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    final subColor = dimmed
        ? fg.withValues(alpha: 0.40)
        : fg.withValues(alpha: 0.55);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: markSize,
            fontWeight: FontWeight.w800,
            color: fg,
            letterSpacing: -2.4,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.jetBrainsMono(
            fontSize: subSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.6,
            color: subColor,
          ),
        ),
      ],
    );
  }
}

class _GhostDeviceCard extends StatefulWidget {
  const _GhostDeviceCard({
    required this.width,
    required this.height,
    required this.compact,
  });

  final double width;
  final double height;
  final bool compact;

  @override
  State<_GhostDeviceCard> createState() => _GhostDeviceCardState();
}

class _GhostDeviceCardState extends State<_GhostDeviceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Empty ghost: laptop_s2.html C.1 → left:73%, top:30%
    final cardW = widget.compact ? 152.0 : 178.0;
    final cardH = widget.compact ? 78.0 : 86.0;
    final left = (0.73 * widget.width).clamp(8.0, widget.width - cardW - 8);
    final top = (0.30 * widget.height).clamp(8.0, widget.height - cardH - 8);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? const Color(0xFFF5EFDE) : SkColors.black;
    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) {
          final t = _ctrl.value;
          final opacity = 0.55 + 0.30 * t;
          return Opacity(
            opacity: opacity,
            child: CustomPaint(
              painter: _DashedBoxPainter(
                color: fg.withValues(alpha: 0.30),
              ),
              child: SizedBox(
                width: cardW,
                height: cardH,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashedBoxPainter extends CustomPainter {
  _DashedBoxPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );
    final path = Path()..addRRect(rrect);
    const dash = 5.0;
    const gap = 5.0;
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final n = math.min(d + dash, m.length);
        canvas.drawPath(m.extractPath(d, n), paint);
        d = n + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBoxPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _AddCta extends StatelessWidget {
  const _AddCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: SkColors.attentionMustard,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 24, 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, size: 18, color: SkColors.black),
              const SizedBox(width: 6),
              Text(
                l.devicesEmptyAddCta,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SkColors.black,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
