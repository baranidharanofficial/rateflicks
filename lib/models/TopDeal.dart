class TopDeal {
  final String id;
  final String url;
  final String imgUrl;

  TopDeal({
    required this.url,
    required this.imgUrl,
    required this.id,
  });

  factory TopDeal.fromJson(Map<String, dynamic> json) {
    return TopDeal(
      url: json['url'],
      imgUrl: json['img_url'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'img_url': imgUrl,
      '_id': id,
    };
  }
}
