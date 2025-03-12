import 'package:googleapis_auth/auth_io.dart';

class GetServerKey{
  Future<String> getServerKeyToken() async{
    final scopes =[
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/userinfo.email',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
          {
            "type": "service_account",
            "project_id": "batting-app-ce894",
            "private_key_id": "f7c57b9f382de54f957731cdff0560053946df52",
            "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQClEKRaQ2Ytf6dD\naNeStuA872qmZRKsovEky/FLF6LbfMyB5tDqyXz6FMZ+ZeL1V/npwnOnwtBgvGeq\nwBC9zU1TClEN14w4iDU0g25esdOcAMUH28DIHjhtGMpm5hc5r9r4dNjA+2RZWiLz\nrGP7D066dhVgWDLRoe3ULiY1kGH48G2SXwTmNFYNVUnNAwfYFDIiJJ6e+6YZPmAW\n24ruEXkspeAfPC0i2OZVgul3D28B2XcfMu/9XnqFIMfAhR+9xs08I3rjOBxep4/Z\nCLL0jXvnlH9NbIQgjxrm/B8pVQ0KsXwBHKKFAS4dyxGUPGHCwDBbX1UF3OPphduG\n8hWiudLTAgMBAAECggEAGXqMI/KrXvKJWvpf7CGWU1GRYMXRMBympEtmn3Syirak\nyphaPyOCywdR7EjF06EUzmRZfdewWn46cjzbWLDL8rlw8XYICuHbdJOlAbDpPPdR\ncnkVNM6VXyGofGGfzCO85QUEQCWNw80KABroA+TE/jsj6Y8zqPAZydqlwzbaKJaU\nltPJZuqX4UUo2VnvNUyHUISKEvgIPrqyM3aXWHuDhLpf3RgyTakz/JrRIch8RW3k\nzPOKORkHkozbscY6ALGCqVpiG3mtck+KqACj5/E+tozyN7D3zuQ4ABf00Q4PPXxV\nCpx/6CFYAkD+qZ99CHprE+gjzGlGCT6/HGHyijn3QQKBgQDTaZuV27v7t3yHV9KN\nRRnfApwx3mzFClD5Ez9NdURNj6bXP6Jq7H77y0nASl1u1rzQ7Oc33I06f8aFiYuZ\nvpTYkWQzCC/Jt0QcBBhLJiy58OBgQ0NGoBb2ZMbxZsssPPnh+Psei7v25Gdn4JJ2\nF3Svz1YEYz+9Eqjwe+oMEs5a+wKBgQDH4K5ffCWUpRSHyNUos64v+Kp46WZooYdx\nymXPkGp5pvg80NH0RaYY9PIOb5CLTi62UhJyRCoCFNRHty3c4Dt8vkHgJ0LO27J8\nPrziRk0nZafafmOPF+cDTHU7TG/BIaTphU7m9OLSHBwStTqbMgpS78N6Bcm6+FlQ\nzArMNwfgCQKBgQCxLTSjJwAoOOI4WzWuB1djOsDEWnA1wiuSUrseo0SW6+kbQ81O\nZt0VEI3ChZBAL98WCTTN8By8BhHOIDPKqZn81fxveFD0cI64HAZwFJIvUtv4UOa0\n7b3QySyha1Cixod1BkEOnHTuuQSgXejg5093d//StYrZXiYPRQolDC28uQKBgQCw\nVsYgUavqH1YkkYeVmCg2BGGJuQjziIaxWopF/Dgjya46IVUJ+CSY4glnuP/CFyDZ\nE0FY9FBHc87w0mgw9Ncmr8f4lUq4q1UljkggLTvGZUYYWudFCCZ0X5ER1tbFggQ3\nTbgVxLkT+169Fox0/Unkb8l6rv6R6KcLxGhGUMqu2QKBgEffwUpK7RXrl8xDteVl\nBbmIVYjGOvazq9x9Li45QZ0MwQw8PeWs9gUuNkWBdwHqwadk4F8TgcrLlC3yRbki\nVEnKvgebyVm+ngRIbzhgGsk0z4TGfnq6r7F5WDfpcJg9V5UtTu3cd5XvbdrxGYH+\nH58Z5zqTYXUg6e39SuqWNOr8\n-----END PRIVATE KEY-----\n",
            "client_email": "firebase-adminsdk-fbsvc@batting-app-ce894.iam.gserviceaccount.com",
            "client_id": "118284146962622360609",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40batting-app-ce894.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          }
      ), scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}