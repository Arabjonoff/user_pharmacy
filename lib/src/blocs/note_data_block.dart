import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class NoteDataBloc {
  final _repository = Repository();
  final _noteFetcher = PublishSubject<List<NoteModel>>();
  final _noteOneFetcher = PublishSubject<List<NoteModel>>();

  Stream<List<NoteModel>> get allNote => _noteFetcher.stream;

  Stream<List<NoteModel>> get oneNote => _noteOneFetcher.stream;

  fetchAllNote() async {
    List<NoteModel> note = await _repository.databaseNote();
    List<NoteModel> noteSort = <NoteModel>[];
    if (note.length > 0) {
      noteSort.add(note[0]);
      for (int i = 0; i < note.length - 1; i++) {
        if (note[i].groupsName != note[i + 1].groupsName) {
          noteSort.add(note[i + 1]);
        }
      }
    }
    _noteFetcher.sink.add(noteSort);
  }

  fetchOneNote(DateTime time) async {
    List<NoteModel> note = await _repository.databaseNote();
    List<NoteModel> noteSort = <NoteModel>[];
    if (note.length > 0) {
      for (int i = 0; i < note.length; i++) {
        if (note[i].dateItem.split(" ")[0] == time.toString().split(" ")[0]) {
          noteSort.add(note[i]);
        }
      }
      noteSort.sort((a, b) => a.dateItem.compareTo(b.dateItem));
    }
    _noteOneFetcher.sink.add(noteSort);
  }

  dispose() {
    _noteFetcher.close();
    _noteOneFetcher.close();
  }
}

final blocNote = NoteDataBloc();
