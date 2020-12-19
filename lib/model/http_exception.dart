class HttpException implements Exception {
  
  final String messageTitle;

  HttpException({this.messageTitle});

  @override
  String toString() {
    
    return messageTitle;
  }
}
