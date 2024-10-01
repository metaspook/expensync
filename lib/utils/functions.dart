import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//-- Config
const _uuid = Uuid();

//-- Public APIs
String uuid() => _uuid.v4();

void unfocus() => FocusManager.instance.primaryFocus?.unfocus();
