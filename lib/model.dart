class Item {
  final String imageurl;
  final String title;
  final String date;
  bool isFavourite;

  Item({
    required this.imageurl,
    required this.title,
    required this.date,
    this.isFavourite = false,
  });
}
