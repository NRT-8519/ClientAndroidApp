import 'package:flutter/foundation.dart';

@immutable
class JWT {
  final String token;
  final String? referenceToken;
  final bool isAuthSuccessful;
  final String? errorMessage;

  const JWT(this.token, this.referenceToken, this.isAuthSuccessful, this.errorMessage);
}