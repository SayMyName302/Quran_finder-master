import 'package:hive/hive.dart';
import 'package:nour_al_quran/shared/entities/bookmarks_dua.dart';

import '../entities/bookmarks_ruqyah.dart';

class RuqyahBookmarksAdapter extends TypeAdapter<BookmarksRuqyah> {
  @override
  final int typeId = 10;

  @override
  BookmarksRuqyah read(BinaryReader reader) {
    final duaId = reader.read();
    final categoryId = reader.read();
    final duaTitle = reader.read();
    final duaRef = reader.read();
    final ayahCount = reader.read();
    final duaText = reader.read();
    final duaTranslation = reader.read();
    final bookmarkPosition = reader.read();
    final duaUrl = reader.read();

    return BookmarksRuqyah(
        duaId: duaId,
        categoryId: categoryId,
        duaTitle: duaTitle,
        duaRef: duaRef,
        ayahCount: ayahCount,
        duaText: duaText,
        duaTranslation: duaTranslation,
        bookmarkPosition: bookmarkPosition,
        duaUrl: duaUrl);
  }

  @override
  void write(BinaryWriter writer, BookmarksRuqyah obj) {
    writer.write(obj.duaId);
    writer.write(obj.categoryId);
    writer.write(obj.duaTitle);
    writer.write(obj.duaRef);
    writer.write(obj.ayahCount);
    writer.write(obj.duaText);
    writer.write(obj.duaTranslation);
    writer.write(obj.bookmarkPosition);
    writer.write(obj.duaUrl);
  }
}
