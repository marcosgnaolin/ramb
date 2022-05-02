class Info {
  final int count;

  Info({
    required this.count
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count']
    );
  }
}