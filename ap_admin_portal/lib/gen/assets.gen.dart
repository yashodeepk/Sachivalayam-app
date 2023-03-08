/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Ellipse_123.png
  AssetGenImage get ellipse123 =>
      const AssetGenImage('assets/images/Ellipse_123.png');

  /// File path: assets/images/Ellipse_128.png
  AssetGenImage get ellipse128 =>
      const AssetGenImage('assets/images/Ellipse_128.png');

  /// File path: assets/images/Ellipse_128_blue.svg
  String get ellipse128Blue => 'assets/images/Ellipse_128_blue.svg';

  /// File path: assets/images/Ellipse_128_green.png
  AssetGenImage get ellipse128GreenPng =>
      const AssetGenImage('assets/images/Ellipse_128_green.png');

  /// File path: assets/images/Ellipse_128_green.svg
  String get ellipse128GreenSvg => 'assets/images/Ellipse_128_green.svg';

  /// File path: assets/images/Ellipse_128_pink.svg
  String get ellipse128Pink => 'assets/images/Ellipse_128_pink.svg';

  /// File path: assets/images/Group_177780.png
  AssetGenImage get group177780 =>
      const AssetGenImage('assets/images/Group_177780.png');

  /// File path: assets/images/Group_177873.png
  AssetGenImage get group177873 =>
      const AssetGenImage('assets/images/Group_177873.png');

  /// File path: assets/images/Group_177882.png
  AssetGenImage get group177882 =>
      const AssetGenImage('assets/images/Group_177882.png');

  /// File path: assets/images/Rectangle_5397.png
  AssetGenImage get rectangle5397 =>
      const AssetGenImage('assets/images/Rectangle_5397.png');

  /// File path: assets/images/Rectangle_5630.png
  AssetGenImage get rectangle5630 =>
      const AssetGenImage('assets/images/Rectangle_5630.png');

  /// File path: assets/images/archive-book.png
  AssetGenImage get archiveBookPng =>
      const AssetGenImage('assets/images/archive-book.png');

  /// File path: assets/images/archive-book.svg
  String get archiveBookSvg => 'assets/images/archive-book.svg';

  /// File path: assets/images/clipboard-tick.png
  AssetGenImage get clipboardTickPng =>
      const AssetGenImage('assets/images/clipboard-tick.png');

  /// File path: assets/images/clipboard-tick.svg
  String get clipboardTickSvg => 'assets/images/clipboard-tick.svg';

  /// File path: assets/images/document-text.png
  AssetGenImage get documentTextPng =>
      const AssetGenImage('assets/images/document-text.png');

  /// File path: assets/images/document-text.svg
  String get documentTextSvg => 'assets/images/document-text.svg';

  /// List of all assets
  List<dynamic> get values => [
        ellipse123,
        ellipse128,
        ellipse128Blue,
        ellipse128GreenPng,
        ellipse128GreenSvg,
        ellipse128Pink,
        group177780,
        group177873,
        group177882,
        rectangle5397,
        rectangle5630,
        archiveBookPng,
        archiveBookSvg,
        clipboardTickPng,
        clipboardTickSvg,
        documentTextPng,
        documentTextSvg
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
