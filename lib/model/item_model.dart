class ItemModel {
  int id;
  String image;
  String name;
  String title;
  String about;
  String price;
  bool favourite = false;

  ItemModel(this.id, this.name, this.image, this.title, this.about, this.price,
      this.cardCount);

  int cardCount = 0;

  int get getId => id;

  String get getImage => image;

  String get getName => name;

  String get getTitle => title;

  String get getAbout => about;

  String get getPrice => price;

  bool get getFavourite => favourite;

  int get getCardCount => cardCount;

  ItemModel.map(dynamic obj) {
    this.id = obj["id"];
    this.image = obj["image"];
    this.name = obj["name"];
    this.title = obj["title"];
    this.about = obj["about"];
    this.price = obj["price"];
    this.cardCount = obj["cardCount"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["image"] = image;
    map["name"] = name;
    map["title"] = title;
    map["about"] = about;
    map["price"] = price;
    map["cardCount"] = cardCount;
    return map;
  }

  ItemModel.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.image = map["image"];
    this.name = map["name"];
    this.title = map["title"];
    this.about = map["about"];
    this.price = map["price"];
    this.cardCount = map["cardCount"];
  }

  static List<ItemModel> itemsModel = <ItemModel>[
    ItemModel(
      0,
      'Амиксин таблетки 125 мг 6 шт',
      'https://uteka.ru/media/768/2/c5/2c58dcf7bb0a26584f9459b201be306a.jpg',
      'Противовирусные',
      'Описание препарата Амиксин®',
      '67 000 so\'m',
      0,
    ),
    ItemModel(
      1,
      'ПАПАВЕРИНА ГИДРОХЛОРИД суппозитории ректальные 20 мг N10',
      'https://apteka.uz/upload/resize_cache/iblock/63f/400_400_1/63fc248df41ca5a90543fdbb03e78a85.jpg',
      'Противовирусные',
      'Описание препарата папаверин',
      '27 100 so\'m',
      0,
    ),
    ItemModel(
      2,
      'Цитрамон-Дарница таб №10',
      'https://e-apteka.com.ua/image/cachewebp/catalog/foto/fotoijyl/3186-370x370.webp',
      'Активные вещества',
      'Описание препарата Цитрамон',
      '5 500 so\'m',
      0,
    ),
    ItemModel(
      3,
      'Линекс форте капс.№28',
      'https://zdravcity.ru/upload/resize_cache/iblock/33f/600_600_Y17536bdc4c4bd27fc2607277fa439b45d/photo_es_994F499D-D28F-47EA-5E05-3E40A030A7DD.jpg',
      'Лактобактерии ацидофильные',
      'Lek d.d.',
      '45 000 so\'m',
      0,
    ),
    ItemModel(
      4,
      'АНАЛЬГИН-ДИБАЗОЛ-ПАПАВЕРИН (ANALGIN-DIBAZOL-PAPAVERINE)',
      'https://interchem.ua/uploads/drugs/andipa10.png',
      'Метамизола натрия моногидрат',
      'Папаверина гидрохлорид',
      '125 000 so\'m',
      0,
    ),
  ];
}
