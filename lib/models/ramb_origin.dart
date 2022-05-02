class Origin {
  final String name;

  Origin({
    required this.name
  });

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      name: json['name']
    );
  }
}