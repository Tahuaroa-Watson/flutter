// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AndroidPlatformView extends StatelessWidget {
  /// Creates a platform view for Android, which is rendered as a
  /// native view.
  /// `viewType` identifies the type of Android view to create.
  const AndroidPlatformView({
    Key key,
    this.onPlatformViewCreated,
    @required this.viewType,
  })  : assert(viewType != null),
        super(key: key);

  /// The unique identifier for the view type to be embedded by this widget.
  ///
  /// A PlatformViewFactory for this type must have been registered.
  final String viewType;

  /// {@template flutter.widgets.platformViews.createdParam}
  /// Callback to invoke after the platform view has been created.
  ///
  /// May be null.
  /// {@endtemplate}
  final PlatformViewCreatedCallback onPlatformViewCreated;

  @override
  Widget build(BuildContext context) {
    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        final AndroidViewController controller =
          PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: params.viewType,
            layoutDirection: TextDirection.ltr,
          )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
        if (onPlatformViewCreated != null) {
          controller.addOnPlatformViewCreatedListener(onPlatformViewCreated);
        }
        return controller..create();
      },
    );
  }
}
