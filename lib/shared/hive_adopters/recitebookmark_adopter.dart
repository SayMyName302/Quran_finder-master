import 'package:hive/hive.dart';
import '../../pages/recitation_category/pages/bookmarks_recitation.dart';

class RecitationBookmarksAdapter extends TypeAdapter<BookmarksRecitation> {
  @override
  final int typeId = 11;

  @override
  BookmarksRecitation read(BinaryReader reader) {
    final recitationName = reader.read();
    final recitationRef = reader.read();
    final recitationIndex = reader.read();
    final contentUrl = reader.read();
    final categoryId = reader.read();
    final imageUrl = reader.read();

    return BookmarksRecitation(
        recitationName: recitationName,
        recitationRef: recitationRef,
        recitationIndex: recitationIndex,
        contentUrl: contentUrl,
        catID: categoryId,
        imageUrl: imageUrl);
  }

  @override
  void write(BinaryWriter writer, BookmarksRecitation obj) {
    writer.write(obj.recitationName);
    writer.write(obj.recitationRef);
    writer.write(obj.recitationIndex);
    writer.write(obj.contentUrl);
    writer.write(obj.catID);
    writer.write(obj.imageUrl);
  }
}
