class Alert {
  final String url;
  final String imgUrl;
  final String alert_price;
  final String current_price;
  final String title;
  final String id;

  Alert({
    required this.url,
    required this.alert_price,
    required this.current_price,
    required this.title,
    required this.imgUrl,
    required this.id,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      url: json['url'],
      alert_price: json['alert_price'],
      current_price: json['current_price'],
      title: json['title'],
      imgUrl: json['imgUrl'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'alert_price': alert_price,
      'current_price': current_price,
      'title': title,
      'imgUrl': imgUrl,
      '_id': id,
    };
  }
}
