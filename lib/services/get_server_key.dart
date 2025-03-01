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
            "private_key_id": "7f737cb2590e6bdf0ba220c1320583d0863d5ce6",
            "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCbs1hi0jYqD7vn\nLeR5CN5utW+b6skMaQGeCpPlymZN9LNwtxJj6dQt82IunZQ6FONmHJbjTC6GW+ZW\nQr0e4uyLGHqhsFaIzpOAlSn95oo+R6XBwE8EyFlhtz/H9YtfL75RzxzabNDOZBEU\n6T2k2vUssMy4dOu3+o8POI/7O2qzQMgoE6pF9GyTALFIriATZl6wn6lHUneN5Lnt\nbL3kdEgYEQ/xaj3c6rup5ZJWHN7EQTbWUbkt9KHypCSdEc0T5tL+p3viLHaSeHFO\nFZb6C99mwZJiOPU2XQ/n4/gNimBd2EcUlGHgSla8i7nUjw9w4+1Y52+o1svDFSqV\ngOX8CLdTAgMBAAECggEALSetrfc2AyvN/GU4WgvC6ouPA0JrrUA02l9J9j4lPl2F\nvt4xJK3XPb5Ujp1ftBqDuoT3E5Nv+MJlQkYXsAHyxQJD6mmIJyP17jgUVhDKrfY8\ncbzyjboHBgpNopGpKmFfyj0NKqGdSwYFWDGukYV4zk22CZbLF+/AFpN6WkuojbR7\np7HrT03oGESz5SrM3YO4EjxsGEPmvSZddqS6rJxBymu2x2REsoxhlt8kKgnmDqQ5\nYrHdtDXKhIa50sGuy005/cIs2lZqe15coh3PFxMX2ifrwmBcmt9zKc3P8WjomYpt\ne3/svfObPY6h/+bkGt16lDHDQGmevE4ebQ2tws+kZQKBgQDKcuTeHGDgJv/vJ8xk\nF4Yb3kyG+oITSdZJpbeCmUlLHtHtD2tV4fB+6CCHFgbwekxxmojvras4vbQnn3Kb\n6zfjrrYXQIBFHG88naueceFsfRYVwVB67twyRxzrli08IzByys0yrqw/CKvaAUT1\n6Dy0l3nOyv893sE5t9ZQStTSDQKBgQDE4tQYwFUzl0nffG2vLxx66Ey0bG0OorBQ\nrnlx4RRlJ49a+uY/9MRmSsmaTY+FiFkMH1PX3WfA9BuFty2xtT8QPo8RPNG9nc/v\nbnF09D09PewIIyHbLe59dJX4hbXcuPRqAuzcX8cyl2jJZhxPwAe6d5mBL1hZrhcC\nqbb3HvM23wKBgFnDK5sXthRs9lmRqdxPWdUNcZz/gaEPwgWRhpZPZOH73lRf29WO\nglWikpmSuKzzbOWKAWFT/XEBG9ndprFfT76R/oa8wKLkAqY7upZcI/k4VQx8VDTN\np7BbO4VxZskdSSP8q5LnQ9QHAjt9CJiHyjLAXu/Drfw+winXSxz6sPYZAoGASQCB\n/Bt0fAigj4kncklZmgkAR/XcCg0wqvnGdf8q/MbKVMWrEhPDrtoUHm6bxLtlqSUE\nhYnGqrjYa6AcBURa+b74dT/D1TbqnrCoyOC2xDpthibgqtBBGatc4CVT5V9+4L/s\n61loFs4lQGfoH3noY69s74WKkNYIGiirer2zGKkCgYA/EQMs4UXkvMTEMguNMFbm\nFqSGYrEQ0jy+u8nfCBiU71xj6RsRLxFKoQx8YCI7wfxO2eptr3Tx9b9Zf4Kl8k32\nYuGMqFY/U1lqwaf5FfL/BbSIVPc5kupkB4WOFYcFI3h6ehTrhQjgDWMyeJb5vTGf\nDUhOPhDxCxchlUQE14+RJQ==\n-----END PRIVATE KEY-----\n",
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