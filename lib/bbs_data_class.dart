class BbsCategory {
  final String categoryNumber;
  final List<BbsBoard> boards;
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
    List<BbsBoard> boardList = list.map((i) => BbsBoard.fromJson(i)).toList();
    return BbsCategory(
      categoryNumber: json['category_number'],
      boards: boardList,
      categoryTotal: json['category_total'],
      categoryName: json['category_name'],
    );
  }
}

class BbsBoard {
  final String url;
  final int category;
  final String categoryName;
  final String directoryName;
  final int categoryOrder;
  final String boardName;

  BbsBoard({
    required this.url,
    required this.category,
    required this.categoryName,
    required this.directoryName,
    required this.categoryOrder,
    required this.boardName,
  });

  factory BbsBoard.fromJson(Map<String, dynamic> json) {
    return BbsBoard(
      url: json['url'],
      category: json['category'],
      categoryName: json['category_name'],
      directoryName: json['directory_name'],
      categoryOrder: json['category_order'],
      boardName: json['board_name'],
    );
  }
}

class BbsThreadInfo {
  final String title;
  final String threadKey;
  final String datUrl;

  BbsThreadInfo({required this.title, required this.threadKey, required this.datUrl});
}

class BbsResponse {
  final String name;
  final String email;
  final String dateAndId;
  final String content;
  final String threadTitle;

  BbsResponse({
    required this.name,
    required this.email,
    required this.dateAndId,
    required this.content,
    required this.threadTitle
  });
}