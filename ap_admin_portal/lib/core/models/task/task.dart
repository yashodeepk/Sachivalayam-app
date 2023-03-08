import '../../../utils/enums.dart';

List<Task> dummyTask = [
  Task(
      taskName: 'Road cleaning work ....................',
      location: 'Ghana',
      numberOfWorkers: '20',
      status: TaskStatus.inReview,
      routing: 'Accra to kumasi',
      dateTime: 'Today'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '10',
      status: TaskStatus.ongoing,
      dateTime: '16/02/202'
          '3'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '10',
      status: TaskStatus.ongoing,
      dateTime: '16/02/202'
          '3'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '10',
      status: TaskStatus.ongoing,
      dateTime: '16/02/202'
          '3'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '10',
      status: TaskStatus.ongoing,
      dateTime: '16/02/202'
          '3'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '10',
      status: TaskStatus.ongoing,
      dateTime: '16/02/202'
          '3'),
  Task(
      taskName: 'Road cleaning work',
      location: 'Ghana',
      numberOfWorkers: '40',
      status: TaskStatus.completed,
      routing: 'Accra to kumasi',
      dateTime: '16/02/2023'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '2',
      status: TaskStatus.ongoing,
      dateTime: '17/02/2023'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '2',
      status: TaskStatus.ongoing,
      dateTime: '17/02/2023'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '2',
      status: TaskStatus.ongoing,
      dateTime: '17/02/2023'),
  Task(
      taskName: 'Road cleaning work',
      routing: 'Accra to kumasi',
      location: 'Ghana',
      numberOfWorkers: '2',
      status: TaskStatus.ongoing,
      dateTime: '17/02/2023'),
];

class Task {
  final String taskName, location, numberOfWorkers, dateTime, routing;
  final TaskStatus status;

  Task(
      {required this.taskName,
      required this.location,
      required this.numberOfWorkers,
      required this.status,
      required this.routing,
      required this.dateTime});
}
