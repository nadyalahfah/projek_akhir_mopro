import 'package:flutter/material.dart';

ImageProvider getDynamicImage(String path) {
  if (path.startsWith('http')) return NetworkImage(path);
  return AssetImage(path) as ImageProvider;
}
