class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://192.168.1.3:8000';
  static const String baseUrl = "http://10.0.2.2:8000";
  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);


  // ============ User Endpoints ============
  static const String userLogin = '/api/auth/login';
  static const String userRegister = '/api/auth/register';
  static const String updateProfile = '/api/auth/update';
  static const String getUser = '/api/auth/users';

  static const String doctors = "/api/doctors";
  static const String appointments = "/api/appointments";
  static const String medicines = "/api/pharmacy/medicines";
  static const String orders = "/api/pharmacy/orders";
  static const String myOrders = "/api/pharmacy/orders/me";
  static const String createPharmacyOrder = "/api/pharmacy/orders";
  static const String myPharmacyOrders = "/api/pharmacy/orders/me";

  static const String initiateEsewaPayment = "/api/payments/esewa/initiate";


}