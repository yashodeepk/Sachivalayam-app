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

  /// File path: assets/images/dummy.png
  AssetGenImage get dummy => const AssetGenImage('assets/images/dummy.png');

  /// List of all assets
  List<AssetGenImage> get values => [dummy];
}

class $AssetsLogoGen {
  const $AssetsLogoGen();

  /// File path: assets/logo/fotter.png
  AssetGenImage get fotter => const AssetGenImage('assets/logo/fotter.png');

  /// File path: assets/logo/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/logo/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [fotter, logo];
}

class $AssetsLottiesGen {
  const $AssetsLottiesGen();

  /// File path: assets/lotties/add.json
  String get add => 'assets/lotties/add.json';

  /// File path: assets/lotties/call.json
  String get call => 'assets/lotties/call.json';

  /// File path: assets/lotties/email.json
  String get email => 'assets/lotties/email.json';

  /// File path: assets/lotties/error.json
  String get error => 'assets/lotties/error.json';

  /// File path: assets/lotties/forgotPassword.json
  String get forgotPassword => 'assets/lotties/forgotPassword.json';

  /// File path: assets/lotties/loader.json
  String get loader => 'assets/lotties/loader.json';

  /// File path: assets/lotties/noTask.json
  String get noTask => 'assets/lotties/noTask.json';

  /// File path: assets/lotties/noWorker.json
  String get noWorker => 'assets/lotties/noWorker.json';

  /// File path: assets/lotties/notification.json
  String get notification => 'assets/lotties/notification.json';

  /// File path: assets/lotties/splashHeader.json
  String get splashHeader => 'assets/lotties/splashHeader.json';

  /// File path: assets/lotties/success.json
  String get success => 'assets/lotties/success.json';

  /// File path: assets/lotties/trash.json
  String get trash => 'assets/lotties/trash.json';

  /// List of all assets
  List<String> get values => [
        add,
        call,
        email,
        error,
        forgotPassword,
        loader,
        noTask,
        noWorker,
        notification,
        splashHeader,
        success,
        trash
      ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/approved.svg
  String get approved => 'assets/svg/approved.svg';

  /// File path: assets/svg/bulk.svg
  String get bulk => 'assets/svg/bulk.svg';

  /// File path: assets/svg/call.svg
  String get call => 'assets/svg/call.svg';

  /// File path: assets/svg/deleteWorker.svg
  String get deleteWorker => 'assets/svg/deleteWorker.svg';

  /// File path: assets/svg/edit.svg
  String get edit => 'assets/svg/edit.svg';

  /// File path: assets/svg/file.svg
  String get file => 'assets/svg/file.svg';

  /// File path: assets/svg/home.svg
  String get home => 'assets/svg/home.svg';

  /// File path: assets/svg/location.svg
  String get location => 'assets/svg/location.svg';

  /// File path: assets/svg/logout.svg
  String get logout => 'assets/svg/logout.svg';

  /// File path: assets/svg/ongoing.svg
  String get ongoing => 'assets/svg/ongoing.svg';

  /// File path: assets/svg/profile.svg
  String get profile => 'assets/svg/profile.svg';

  /// File path: assets/svg/routing.svg
  String get routing => 'assets/svg/routing.svg';

  /// File path: assets/svg/search.svg
  String get search => 'assets/svg/search.svg';

  /// File path: assets/svg/single.svg
  String get single => 'assets/svg/single.svg';

  /// File path: assets/svg/task.svg
  String get task => 'assets/svg/task.svg';

  /// File path: assets/svg/taskWorkers.svg
  String get taskWorkers => 'assets/svg/taskWorkers.svg';

  /// File path: assets/svg/trash.svg
  String get trash => 'assets/svg/trash.svg';

  /// File path: assets/svg/upload.svg
  String get upload => 'assets/svg/upload.svg';

  /// File path: assets/svg/workers.svg
  String get workers => 'assets/svg/workers.svg';

  /// List of all assets
  List<String> get values => [
        approved,
        bulk,
        call,
        deleteWorker,
        edit,
        file,
        home,
        location,
        logout,
        ongoing,
        profile,
        routing,
        search,
        single,
        task,
        taskWorkers,
        trash,
        upload,
        workers
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
  static const $AssetsLottiesGen lotties = $AssetsLottiesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
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
