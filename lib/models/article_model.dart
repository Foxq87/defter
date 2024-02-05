class Article {
  final String id;
  final String thumbmnailUrl;
  final String title;
  final String authorId;
  final int readingTime;
  final int reshareCount;
  final int commentCount;
  final List bookmarks;
  final Map likes;

  Article({
    required this.id,
    required this.thumbmnailUrl,
    required this.title,
    required this.authorId,
    required this.readingTime,
    required this.reshareCount,
    required this.commentCount,
    required this.bookmarks,
    required this.likes,
  });
}

List articles = [
  Article(
    id: '0',
    thumbmnailUrl:
        "https:substackcdn.com/image/fetch/w_1360,c_limit,f_webp,q_auto:best,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2Fc9d041c0-0e71-4c6c-9896-509b8697b45e_1024x1024.png",
    title: "What people ask me most. Also, some answers.",
    authorId: "01",
    readingTime: 7,
    reshareCount: 2,
    commentCount: 5,
    bookmarks: ["02"],
    likes: {},
  ),
  Article(
    id: '1',
    thumbmnailUrl:
        "https:substackcdn.com/image/fetch/w_1360,c_limit,f_webp,q_auto:best,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2Fc9d041c0-0e71-4c6c-9896-509b8697b45e_1024x1024.png",
    title: "How to sleep in a better way?",
    authorId: "01",
    readingTime: 7,
    reshareCount: 2,
    commentCount: 5,
    bookmarks: ["02"],
    likes: {},
  ),
  Article(
    id: '2',
    thumbmnailUrl:
        "https:substackcdn.com/image/fetch/w_1360,c_limit,f_webp,q_auto:best,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2Fc9d041c0-0e71-4c6c-9896-509b8697b45e_1024x1024.png",
    title: "You don't know how to spend money.",
    authorId: "01",
    readingTime: 7,
    reshareCount: 2,
    commentCount: 5,
    bookmarks: ["02"],
    likes: {},
  ),
];
