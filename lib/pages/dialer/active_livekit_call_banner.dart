import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'package:extera_next/config/app_settings.dart';
import 'package:extera_next/generated/l10n/l10n.dart';
import 'package:extera_next/pages/dialer/livekit_call_screen.dart';

class ActiveLiveKitCallBanner extends StatefulWidget {
  final Room room;
  const ActiveLiveKitCallBanner({required this.room, super.key});

  @override
  State<ActiveLiveKitCallBanner> createState() => _ActiveLiveKitCallBannerState();
}

class _ActiveLiveKitCallBannerState extends State<ActiveLiveKitCallBanner> {
  StreamSubscription? _stateSub;
  StreamSubscription? _timelineSub;
  final Set<String> _callInviteSenders = {};

  @override
  void initState() {
    super.initState();
    _stateSub = widget.room.client.onRoomState.stream
        .where((u) =>
            u.roomId == widget.room.id &&
            u.state.type == 'org.matrix.msc3401.call.member')
        .listen((_) {
      if (mounted) setState(() {});
    });
    _timelineSub = widget.room.client.onTimelineEvent.stream
        .where((event) =>
            event.room.id == widget.room.id && event.type == 'm.call.invite')
        .listen((event) {
      _callInviteSenders.add(event.senderId);
      if (mounted) setState(() {});
      Future.delayed(const Duration(seconds: 90), () {
        _callInviteSenders.remove(event.senderId);
        if (mounted) setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _timelineSub?.cancel();
    super.dispose();
  }

  bool _hasActiveCall() {
    final callMembers = widget.room.states['org.matrix.msc3401.call.member'];
    if (callMembers != null && callMembers.isNotEmpty) {
      for (final entry in callMembers.entries) {
        final event = entry.value;
        final content = event.content;
        if (content['m.room.member'] == 'leave') continue;
        final memberEvent = widget.room.states['m.room.member']?[event.senderId];
        if (memberEvent?.content['membership'] != 'join') continue;
        return true;
      }
    }
    if (_callInviteSenders.isNotEmpty) {
      for (final senderId in _callInviteSenders) {
        final memberEvent = widget.room.states['m.room.member']?[senderId];
        if (memberEvent?.content['membership'] == 'join') return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!AppSettings.experimentalLiveKit.value) return const SizedBox.shrink();
    if (!_hasActiveCall()) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: FilledButton.tonal(
        onPressed: () => openLiveKitCall(context, widget.room.id),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.video_call),
            const SizedBox(width: 18),
            Text(L10n.of(context).elementCallLiveKit),
          ],
        ),
      ),
    );
  }
}
