import 'package:flutter/material.dart';

Route _routeFromWidget(Widget widget) => MaterialPageRoute(builder: (_) => widget);

void pushPage(BuildContext ctx, Widget page) => Navigator.of(ctx).push(_routeFromWidget(page));
void replacePage(BuildContext ctx, Widget page) => Navigator.of(ctx).pushReplacement(_routeFromWidget(page));
