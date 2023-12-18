class Offer {
  final String url;
  final String img_url;
  final String price;
  final String offer_price;
  final String title;
  final String id;

  Offer({
    required this.url,
    required this.price,
    required this.offer_price,
    required this.title,
    required this.img_url,
    required this.id,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      url: json['url'],
      price: json['price'],
      offer_price: json['offer_price'],
      title: json['title'],
      img_url: json['img_url'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'price': price,
      'offer_price': offer_price,
      'title': title,
      'img_url': img_url,
      '_id': id,
    };
  }
}
