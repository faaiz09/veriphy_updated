// lib/constants/api_constants.dart

class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://veriphy.io';
  static const String apiPath = '/api/v1';
  static const String chatBaseUrl = 'https://bank.ariticapp.com';

  // Authentication Endpoints
  static const String login = '$apiPath/loginservice/login';
  static const String authenticate = '$apiPath/loginservice/authenticate';
  static const String logout = '$apiPath/loginservice/logout';

  // Dashboard Endpoints
  static const String dashboard = '$apiPath/dashboardservice/dashboard';
  static const String customerList = '$apiPath/dashboardservice/customerlist';
  static const String customerListFilter = '$apiPath/dashboardservice/customerlist/filter';
  
  // Customer Process Endpoints
  static const String initiateProcess = '$apiPath/userprocessservice/initiate';
  static const String reinitiateProcess = '$apiPath/userprocessservice/reinitiate';
  static const String completeProcess = '$apiPath/userprocessservice/complete';
  static const String resetCustomer = '$apiPath/customerservice/resetdata';
  static const String editCustomer = '$apiPath/customerservice/edit';

  // Document Endpoints
  static const String userAndDocInfo = '$apiPath/documentservice/useranddocmeta';
  static const String tagDocument = '$apiPath/documentservice/tagdocment';
  static const String addDocument = '$apiPath/documentservice/adddocument';

  // Profile Endpoints
  static const String profileBasicInfo = '$apiPath/profileservice/basicinfo';
  static const String updateProfile = '$apiPath/profileservice/updateprofile';

  // Activity Endpoints
  static const String activity = '$apiPath/activityservice/activity';

  // Task Endpoints
  static const String viewTasks = '$apiPath/taskservice/viewtasks';
  static const String createTask = '$apiPath/taskservice/createtask';
  static const String updateTask = '$apiPath/taskservice/updatetask';
  static const String viewTaskTypes = '$apiPath/taskservice/viewtasktype';
  static const String viewTAT = '$apiPath/taskservice/viewtat';
  static const String stageData = '$apiPath/taskservice/stage';

  // Product Endpoints
  static const String productTypeList = '$apiPath/productservice/producttypelist';
  static const String productList = '$apiPath/productservice/productlist';
  static const String documentList = '$apiPath/productservice/documentlist';

  // Notification Endpoints
  static const String newNotifications = '$apiPath/notificationservice/newnotification';
  static const String updateNotification = '$apiPath/notificationservice/updatenotification';

  // Chat Endpoints 
  static const String getConversationId = '$apiPath/whatsappservice/conversationid';
  static const String chatEndpoint = '$chatBaseUrl/chatext/admin.php';

  // Get full URL
  static String getFullUrl(String endpoint) => baseUrl + endpoint;
}