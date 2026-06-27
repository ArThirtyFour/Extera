import 'package:matrix/matrix.dart';

extension CallMembersExtension on Room {
  Set<String> get callMembers {
    final callMembers = states['org.matrix.msc3401.call.member'];
    final members = <String>{};
    if (callMembers != null && callMembers.isNotEmpty) {
      for (final entry in callMembers.entries) {
        final content = entry.value.content;
        if (content.isEmpty) continue;
        final membershipId = content['membershipID'] as String?;
        final deviceId = content['device_id'] as String?;
        if (membershipId == null || deviceId == null) continue;
        final mxId = membershipId.replaceAll(':$deviceId', ''); // i am not sure tho
        members.add(mxId);
      }
    }
    return members;
  }

  int get callMembersCount {
    return callMembers.length;
  }
}
