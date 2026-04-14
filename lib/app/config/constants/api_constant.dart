class ApiConstant {
  /*
   * Constact related to server communication
   */

  //* ======================================================================
  //* Changeing Area
  //

  // Live Server
  // static const SERVER_IP = 'http://217.73.238.134';
  // static const String SERVER_IP_PORT = 'http://217.73.238.134:182';

  // Live Server
  // static const SERVER_IP = 'https://qposs.com';
  // static const String SERVER_IP_PORT = '$SERVER_IP:82';

  // Local Server
  static const SERVER_IP = 'http://localhost';
  static const String SERVER_IP_PORT = 'http://localhost:9000';

  // static const String BASE_URL = '$SERVER_IP_PORT/api/';
  static const String BASE_URL = '$SERVER_IP_PORT/api/';
  static const String RTMP_BASE_URL = 'rtmp://217.73.238.134:1935/live/';
  // static const String RTMP_BASE_URL = 'rtmp://localhost:1935/live/';

  //* Socket Server Communication

  static const String CHAT_SERVER_IP_PORT = SERVER_IP_PORT; //Live Chat

  //* ========================================================== Response Keys =========================================================

  //Response Area.
  static const String FULL_RESPONSE = 'Full Response';
  static const String DATA_RESPONSE = 'data';
  //Response Key
  static const STATUS_CODE_KEY = 'status';
}
