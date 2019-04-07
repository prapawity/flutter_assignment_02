
//this model is OO case create for example but not use
class modelData{
  final int id;
  final String body;
  final bool state_show;

  modelData({
    this.id,this.body,this.state_show
  });
  factory modelData.fromJson(Map<String, dynamic> json){
    return modelData(
      id: json["id"],
      body: json["body"] as String, 
      state_show: json ["state_show"] as bool,

    );
  }
}
