class SemModel {
  String sem;
  List<String> subs;

  SemModel({this.sem, this.subs});

  SemModel.fromJson(Map<String, dynamic> json) {
    sem = json['sem'];
    subs = json['subs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sem'] = this.sem;
    data['subs'] = this.subs;
    return data;
  }
}
