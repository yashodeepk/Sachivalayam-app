library booky_app.globals;

bool isLoggedIn = false;
String serverUrl = 'ec2-65-0-138-213.ap-south-1.compute.amazonaws.com';
// String serverUrl = 'localhost:8080';
String loginPath = '/api/auth/signin';
String statusCountPath = '/api/task_status_count';
String barGraphDataPath = '/api/task_BarGraph';
String pieGraphDataPath = '/api/task_PieGraph';
String taskDataPath = '/api/task_data';
String zoneDataPath = '/api/all_zone';
String allZoneDataPath = '/api/zone';
String workerAttendanceDataPath = '/api/user/worker/attendance';
String secretaryDataPath = '/api/user/secretary';
String userDataPath = '/api/user';
String bulUploadSecretoryDataPath = '/api/user/secretory_bulk_upload';
String signupDataPath = '/api/auth/signup';
String getDownloadDataPath = '/api/getdownloadlink';
String secretoryTemplateName = 'secretory_template';
// String secretoryTemplateName = 'worker_template';
