class HttpResult {
  final bool isSuccess;
  final int status;
  var result;

  HttpResult({
    this.isSuccess,
    this.result,
    this.status,
  });
}
