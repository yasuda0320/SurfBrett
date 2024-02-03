class BbsCategory {
  final String categoryNumber;
  final List<Board> boards;
  final int categoryTotal;
  final String categoryName;

  BbsCategory({
    required this.categoryNumber,
    required this.boards,
    required this.categoryTotal,
    required this.categoryName,
  });

  factory BbsCategory.fromJson(Map<String, dynamic> json) {
    var list = json['category_content'] as List;
    List<Board> boardList = list.map((i) => Board.fromJson(i)).toList();
    return BbsCategory(
      categoryNumber: json['category_number'],
      boards: boardList,
      categoryTotal: json['category_total'],
      categoryName: json['category_name'],
    );
  }
}

class Board {
  final String url;
  final int category;
  final String categoryName;
  final String directoryName;
  final int categoryOrder;
  final String boardName;

  Board({
    required this.url,
    required this.category,
    required this.categoryName,
    required this.directoryName,
    required this.categoryOrder,
    required this.boardName,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      url: json['url'],
      category: json['category'],
      categoryName: json['category_name'],
      directoryName: json['directory_name'],
      categoryOrder: json['category_order'],
      boardName: json['board_name'],
    );
  }
}

class ThreadInfo {
  final String title;
  final String url;

  ThreadInfo({required this.title, required this.url});
}
