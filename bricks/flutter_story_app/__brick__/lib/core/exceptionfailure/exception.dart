class ServerException implements Exception{
  final String msg;
  const ServerException({required this.msg});
}
class ConnectionException implements Exception{
  final String msg;
  const ConnectionException({required this.msg});
}