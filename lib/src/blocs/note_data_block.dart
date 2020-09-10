import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/model/note/note_data_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class NoteDataBloc {
  final _repository = Repository();
  final _noteFetcher = PublishSubject<List<NoteModel>>();

  Observable<List<NoteModel>> get allNote => _noteFetcher.stream;

  fetchAllChat() async {
    List<NoteModel> note = await _repository.databaseNote();

    _noteFetcher.sink.add(note);
  }

  dispose() {
    _noteFetcher.close();
  }
}

final blocNote = NoteDataBloc();
