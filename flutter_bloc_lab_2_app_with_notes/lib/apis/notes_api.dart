import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc_lab_2_app_with_notes/model.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}

@immutable
class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null,
    );
  }
}
