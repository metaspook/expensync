// Copyright (c) 2024, Metaspook.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT-style license that can be found in the LICENSE file.

import 'dart:async';

/// CRUD operations abstract to implement on repository.
abstract class CRUD<T extends Object, R extends Object?> {
  /// Creates data.
  /// {@template CU}
  /// * Takes [value] as `Object` type if not annotated in `T`.
  /// {@endtemplate}
  /// {@template CRUD}
  /// * Returns Error message as `String?` and `null` indicates success.
  /// {@endtemplate}
  Future<String?> create(String id, {required T value});

  /// Reads data (returns as record).
  /// {@macro CRUD}
  /// * Returns data as `Object?` type if not annotated in class's `R`.
  // TODO: implement read
  Future<(String?, R)> read(String id);

  /// Updates data.
  /// {@macro CU}
  /// {@macro CRUD}
  Future<String?> update(String id, {required T value});

  /// Deletes data.
  /// {@macro CRUD}
  Future<String?> delete(String id);
}
