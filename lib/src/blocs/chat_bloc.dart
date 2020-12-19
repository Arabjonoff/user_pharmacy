import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  final _repository = Repository();
  final _chatFetcher = PublishSubject<ChatApiModel>();

  Observable<ChatApiModel> get allChat => _chatFetcher.stream;

  ChatApiModel model;

  fetchAllChat(int page) async {
    ChatApiModel saleModel = await _repository.fetchGetAppMessage(page);
    if (saleModel != null) {
      model = new ChatApiModel(
          count: page,
          next: saleModel.next,
          previous: saleModel.previous,
          results: saleModel.results);

      _chatFetcher.sink.add(model);
    }
  }

  dispose() {
    _chatFetcher.close();
  }
}

final blocChat = ChatBloc();
