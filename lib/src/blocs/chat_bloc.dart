import 'package:pharmacy/src/model/api/category_model.dart';
import 'package:pharmacy/src/model/chat/chat_api_model.dart';
import 'package:pharmacy/src/resourses/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  final _repository = Repository();
  final _chatFetcher = PublishSubject<ChatApiModel>();

  Observable<ChatApiModel> get allChat => _chatFetcher.stream;



  fetchAllChat(int page) async {

    ChatApiModel saleModel = await _repository.fetchGetAppMessage(page);


    _chatFetcher.sink.add(saleModel);
  }

  dispose() {
    _chatFetcher.close();
  }
}

final blocChat = ChatBloc();
