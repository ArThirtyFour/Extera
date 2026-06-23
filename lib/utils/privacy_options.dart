import 'package:matrix/matrix.dart';

import 'package:extera_next/config/app_settings.dart';

bool hasIndividualPrivacyOptionsEnabled(Client client, String roomId) {
  return client.accountData.containsKey(
    'xyz.extera.room_privacy_settings.$roomId',
  );
}

bool shouldSendPublicReadReceipts(Client client, String roomId) {
  if (!hasIndividualPrivacyOptionsEnabled(client, roomId)) {
    return AppSettings.sendPublicReadReceipts.value;
  }
  final content =
      client.accountData['xyz.extera.room_privacy_settings.$roomId']!.content;
  return content.containsKey('read_receipts')
      ? content.tryGet<bool>('read_receipts')!
      : AppSettings.sendPublicReadReceipts.value;
}

bool shouldSendTypingNotifications(Client client, String roomId) {
  if (!hasIndividualPrivacyOptionsEnabled(client, roomId)) {
    return AppSettings.sendTypingNotifications.value;
  }
  final content =
      client.accountData['xyz.extera.room_privacy_settings.$roomId']!.content;
  return content.containsKey('typing_notifications')
      ? content.tryGet<bool>('typing_notifications')!
      : AppSettings.sendTypingNotifications.value;
}

bool shouldAutoLoadMedia(Client client, String roomId) {
  if (!hasIndividualPrivacyOptionsEnabled(client, roomId)) {
    return AppSettings.autoLoadMedia.value;
  }
  final content =
      client.accountData['xyz.extera.room_privacy_settings.$roomId']!.content;
  return content.containsKey('auto_load_media')
      ? content.tryGet<bool>('auto_load_media')!
      : AppSettings.autoLoadMedia.value;
}
