import 'dart:convert';

NewTaskDetails newTaskDetailsFromJson(String str) => NewTaskDetails.fromJson(json.decode(str));

String newTaskDetailsToJson(NewTaskDetails data) => json.encode(data.toJson());

class NewTaskDetails {
  NewTaskDetails({
    this.workers,
    this.tasks,
    this.workArea,
  });

  final List<Worker>? workers;
  final List<String>? tasks;
  final List<WorkArea>? workArea;

  factory NewTaskDetails.fromJson(Map<String, dynamic> json) => NewTaskDetails(
        workers: json["workers"] == null ? [] : List<Worker>.from(json["workers"]!.map((x) => Worker.fromJson(x))),
        tasks: json["tasks"] == null ? [] : List<String>.from(json["tasks"]!.map((x) => x)),
        workArea: json["workArea"] == null ? [] : List<WorkArea>.from(json["workArea"]!.map((x) => WorkArea.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "workers": workers == null ? [] : List<dynamic>.from(workers!.map((x) => x.toJson())),
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x)),
        "workArea": workArea == null ? [] : List<dynamic>.from(workArea!.map((x) => x.toJson())),
      };
}

class WorkArea {
  WorkArea({this.name});

  final String? name;

  factory WorkArea.fromJson(Map<String, dynamic> json) => WorkArea(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

class Worker {
  Worker({
    this.name,
    this.email,
  });

  final String? name;
  final String? email;

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
      };
}
