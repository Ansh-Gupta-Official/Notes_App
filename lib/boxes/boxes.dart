import 'package:hive/hive.dart';
import 'package:untitled1/models/notes.dart';
class Boxes {
  static Box<Notes> getData() => Hive.box<Notes>('notes');
}

