class FirebaseHelper {
  static final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  static final String serverKey =
      'AAAA10wQdj8:APA91bFknfddDLEOQli065hllptT4H0kLywMVIYj7wu155VUqEcyQoG02B7dDtoXVdi0vPSbti2EocixQzKWKRH-QThXoHDMKpQi4fKifRPbOOuMbVSrnc6UClkDQGgXG9jYw7os5Igw';

  static Map<String, dynamic> getMessageBody(String token) {
    return {
      'notification': {
        'body': 'You\'ve got new message!',
        'title': 'WorkshopsApp',
      },
      'priority': 'high',
      'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
      'to': token,
    };
  }
}
