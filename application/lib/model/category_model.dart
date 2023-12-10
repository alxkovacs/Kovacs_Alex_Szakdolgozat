class CategoryModel {
  final String name;
  final String emoji;

  CategoryModel(this.name, this.emoji);
}

List<CategoryModel> categories = [
  CategoryModel('Tisztítószerek', '🧼'),
  CategoryModel('Súrolószerek', '🪣'),
  CategoryModel('Kézi eszközök', '🧹'),
  CategoryModel('Elektromos takarítógépek', '🔌'),
  CategoryModel('Kerti és kültéri tisztítóeszközök', '🌿'),
  CategoryModel('Autótisztítási termékek', '🚗'),
  CategoryModel('Ablaktisztítás', '🪟'),
  CategoryModel('Fürdőszoba tisztítás', '🛁'),
  CategoryModel('Konyhai tisztítás', '🍽️'),
  CategoryModel('Fertőtlenítő és higiéniai termékek', '🦠'),
  CategoryModel('Illatosítók és levegőfrissítők', '💐'),
  CategoryModel('Védőfelszerelés', '🧤'),
  CategoryModel('Speciális tisztítószerek', '✨'),
];
