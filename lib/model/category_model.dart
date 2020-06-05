class CategoryModel {
  int id;
  String name;
  List<SubCategoryModel> subCategory;

  CategoryModel(this.id, this.name, this.subCategory);

  static List<CategoryModel> categoryModel = <CategoryModel>[
    CategoryModel(0, 'Аллергология', subCategoryList),
    CategoryModel(1, 'Гематологи', subCategoryList),
    CategoryModel(2, 'Гигиена', subCategoryList),
    CategoryModel(3, 'Диагностика', subCategoryList),
    CategoryModel(4, 'Диагностика', subCategoryList),
    CategoryModel(5, 'Кардиология', subCategoryList),
    CategoryModel(6, 'Наркология', subCategoryList),
    CategoryModel(7, 'Неврология', subCategoryList),
    CategoryModel(8, 'Онкология', subCategoryList),
    CategoryModel(0, 'Аллергология', subCategoryList),
    CategoryModel(1, 'Гематологи', subCategoryList),
    CategoryModel(2, 'Гигиена', subCategoryList),
    CategoryModel(3, 'Диагностика', subCategoryList),
    CategoryModel(4, 'Диагностика', subCategoryList),
    CategoryModel(5, 'Кардиология', subCategoryList),
    CategoryModel(6, 'Наркология', subCategoryList),
    CategoryModel(7, 'Неврология', subCategoryList),
    CategoryModel(8, 'Онкология', subCategoryList),
  ];

  static List<SubCategoryModel> subCategoryList = <SubCategoryModel>[
    SubCategoryModel(0, 'Антисептик'),
    SubCategoryModel(1, 'Гигиена интемная'),
    SubCategoryModel(2, 'Потливость'),
    SubCategoryModel(3, 'Тампоны'),
    SubCategoryModel(0, 'Антисептик'),
    SubCategoryModel(1, 'Гигиена интемная'),
    SubCategoryModel(2, 'Потливость'),
    SubCategoryModel(3, 'Тампоны'),
  ];
}

class SubCategoryModel {
  int id;
  String name;

  SubCategoryModel(this.id, this.name);
}
