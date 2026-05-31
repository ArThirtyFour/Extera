import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'message_bubble.dart';
import 'message_modern.dart';

class Message extends StatelessWidget {
  final Event event;
  final Event? nextEvent;
  final Event? previousEvent;
  final bool displayReadMarker;
  final void Function(Event, Offset?) onSelect;
  final void Function(Event) onInfoTab;
  final void Function(String, String?) scrollToEventId;
  final void Function(Event) onSwipe;
  final void Function() onMention;
  final bool longPressSelect;
  final bool selected;
  final Timeline timeline;
  final bool highlightMarker;
  final bool animateIn;
  final bool wallpaperMode;
  final ScrollController? scrollController;
  final List<Color> colors;
  final bool gradient;
  final bool singleSelected;
  final Thread? thread;
  final bool hasBeenRead;
  final bool useBubbleLayout;

  const Message(
    this.event, {
    this.nextEvent,
    this.previousEvent,
    this.displayReadMarker = false,
    this.longPressSelect = false,
    this.gradient = false,
    this.singleSelected = false,
    this.hasBeenRead = false,
    this.thread,
    required this.onSelect,
    required this.onInfoTab,
    required this.scrollToEventId,
    required this.onSwipe,
    this.selected = false,
    required this.timeline,
    this.highlightMarker = false,
    this.animateIn = false,
    this.wallpaperMode = false,
    required this.onMention,
    this.scrollController,
    required this.colors,
    this.useBubbleLayout = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (useBubbleLayout) {
      return MessageBubble(
        event,
        onSelect: onSelect,
        onInfoTab: onInfoTab,
        scrollToEventId: scrollToEventId,
        onSwipe: onSwipe,
        timeline: timeline,
        onMention: onMention,
        colors: colors,
        animateIn: animateIn,
        displayReadMarker: displayReadMarker,
        gradient: gradient,
        hasBeenRead: hasBeenRead,
        highlightMarker: highlightMarker,
        key: key,
        longPressSelect: longPressSelect,
        nextEvent: nextEvent,
        previousEvent: previousEvent,
        scrollController: scrollController,
        selected: selected,
        singleSelected: singleSelected,
        thread: thread,
        wallpaperMode: wallpaperMode,
      );
    } else {
      return MessageModern(
        event,
        onSelect: onSelect,
        onInfoTab: onInfoTab,
        scrollToEventId: scrollToEventId,
        onSwipe: onSwipe,
        timeline: timeline,
        onMention: onMention,
        colors: colors,
        animateIn: animateIn,
        displayReadMarker: displayReadMarker,
        gradient: gradient,
        hasBeenRead: hasBeenRead,
        highlightMarker: highlightMarker,
        key: key,
        longPressSelect: longPressSelect,
        nextEvent: nextEvent,
        previousEvent: previousEvent,
        scrollController: scrollController,
        selected: selected,
        singleSelected: singleSelected,
        thread: thread,
        wallpaperMode: wallpaperMode,
      );
    }
  }
}
