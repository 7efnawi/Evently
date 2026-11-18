import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/event_model.dart';

enum SyncOpType {
  create,
  update,
  delete,
  toggleFavorite,
}

class SyncOperation {
  final String id;
  final SyncOpType type;
  final String? eventId;
  final EventModel? event;
  final bool? isFavorite;
  final DateTime timestamp;

  SyncOperation({
    required this.id,
    required this.type,
    this.eventId,
    this.event,
    this.isFavorite,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'eventId': eventId ?? event?.id,
      'event': event?.toMap(),
      'isFavorite': isFavorite,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SyncOperation.fromMap(Map<String, dynamic> map) {
    return SyncOperation(
      id: map['id'] as String,
      type: SyncOpType.values.byName(map['type'] as String),
      eventId: map['eventId'] as String?,
      event: map['event'] != null
          ? EventModel.fromMap(Map<String, dynamic>.from(map['event'] as Map))
          : null,
      isFavorite: map['isFavorite'] as bool?,
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class PendingSyncQueue {
  static const String _queueKey = 'evently_pending_sync_queue';

  Future<List<SyncOperation>> getOperations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_queueKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((item) => SyncOperation.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> enqueue(SyncOperation op) async {
    final ops = await getOperations();
    ops.add(op);
    await _save(ops);
  }

  Future<void> remove(String opId) async {
    final ops = await getOperations();
    ops.removeWhere((item) => item.id == opId);
    await _save(ops);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
  }

  Future<void> _save(List<SyncOperation> ops) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(ops.map((o) => o.toMap()).toList());
    await prefs.setString(_queueKey, encoded);
  }
}
