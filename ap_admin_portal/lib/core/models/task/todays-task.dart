// To parse this JSON data, do
//
//     final todaysTask = todaysTaskFromJson(jsonString);

import 'dart:convert';

import '../../../utils/enums.dart';

TaskToday taskTodayFromJson(String str) => TaskToday.fromJson(json.decode(str));

String taskTodayToJson(TaskToday data) => json.encode(data.toJson());

class Tasks {
  final String? id;
  final String? taskName;
  final TaskStatus? taskStatus;
  final String? fromWorkArea;
  final String? toWorkArea;
  final List<String>? assignedWorker;
  final List<String>? beforeImage;
  final List<String>? afterImage;
  final String? assignedBy;
  final String? assignersId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  Tasks({
    this.id,
    this.taskName,
    this.taskStatus,
    this.fromWorkArea,
    this.toWorkArea,
    this.assignedWorker,
    this.beforeImage,
    this.afterImage,
    this.assignedBy,
    this.assignersId,
    this.createdAt,
    this.updatedAt,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
        id: json["_id"],
        taskName: json["task_name"] ?? '',
        taskStatus: taskStatusValues.map![json["task_status"]],
        fromWorkArea: json["from_work_area"] ?? '',
        toWorkArea: json["to_work_area"] ?? '',
        assignedWorker: json["assigned_worker"] == null ? [] : List<String>.from(json["assigned_worker"]!.map((x) => x)),
        beforeImage: json["before_image"] == null ? [] : List<String>.from(json["before_image"]!.map((x) => x)),
        afterImage: json["after_image"] == null ? [] : List<String>.from(json["after_image"]!.map((x) => x)),
        assignedBy: json["assigned_by"] ?? '',
        assignersId: json["assigners_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "task_name": taskName,
        "task_status": taskStatusValues.reverse[taskStatus],
        "from_work_area": fromWorkArea,
        "to_work_area": toWorkArea,
        "assigned_worker": assignedWorker == null ? [] : List<dynamic>.from(assignedWorker!.map((x) => x)),
        "before_image": beforeImage == null ? [] : List<dynamic>.from(beforeImage!.map((x) => x)),
        "after_image": afterImage == null ? [] : List<dynamic>.from(afterImage!.map((x) => x)),
        "assigned_by": assignedBy,
        "assigners_id": assignersId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class TaskToday {
  final int? totalTask;

  final int? completed;
  final int? ongoing;
  final int? inReview;
  final List<Tasks>? tasks;
  TaskToday({
    this.totalTask,
    this.completed,
    this.ongoing,
    this.inReview,
    this.tasks,
  });

  factory TaskToday.fromJson(Map<String, dynamic> json) => TaskToday(
        totalTask: json["totaltask"],
        completed: json["completed"],
        ongoing: json["ongoing"],
        inReview: json["inreview"],
        tasks: json["tasks"] == null ? [] : List<Tasks>.from(json["tasks"]!.map((x) => Tasks.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totaltask": totalTask,
        "completed": completed,
        "ongoing": ongoing,
        "inreview": inReview,
        "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
      };
}
