class SyncData {
  int id;
  String type;
  String data;

  SyncData({required this.id, required this.type, required this.data});

  factory SyncData.fromJson(Map<String, dynamic> json) {
    return SyncData(
      id: json["id"],
      type: json["operationType"],
      data: json["data"]
    );
  }
}