class DownloadLink {
  DownloadLink({
    required this.id,
    required this.name,
    required this.link,
  });

  String id;
  String name;
  String link;

  factory DownloadLink.fromJson(Map<String, dynamic> json) => DownloadLink(
        id: json["_id"],
        name: json["name"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "link": link,
      };
}
