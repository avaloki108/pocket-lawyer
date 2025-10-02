import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, Completer<void>> _pendingOperations = {};
  final Queue<PerformanceTask> _taskQueue = Queue<PerformanceTask>();
  Timer? _processingTimer;
  bool _isProcessing = false;

  /// Execute operation with debouncing to prevent rapid successive calls
  Future<T> debounce<T>(
    String key,
    Future<T> Function() operation, {
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) async {
    if (_pendingOperations.containsKey(key)) {
      await _pendingOperations[key]!.future;
    }

    final completer = Completer<void>();
    _pendingOperations[key] = completer;

    try {
      await Future.delayed(debounceDuration);
      final result = await operation();
      return result;
    } finally {
      _pendingOperations.remove(key);
      completer.complete();
    }
  }

  /// Execute operation with throttling to limit execution frequency
  Future<T> throttle<T>(
    String key,
    Future<T> Function() operation, {
    Duration throttleDuration = const Duration(milliseconds: 500),
  }) async {
    final lastExecution = _pendingOperations[key];
    if (lastExecution != null) {
      return operation(); // Execute immediately if throttling allows
    }

    final completer = Completer<void>();
    _pendingOperations[key] = completer;

    try {
      final result = await operation();
      await Future.delayed(throttleDuration);
      return result;
    } finally {
      _pendingOperations.remove(key);
      completer.complete();
    }
  }

  /// Queue background tasks for sequential processing
  void queueBackgroundTask(
    String taskId,
    Future<void> Function() task, {
    Duration delay = Duration.zero,
  }) {
    _taskQueue.add(PerformanceTask(taskId, task, delay));
    _startProcessing();
  }

  void _startProcessing() {
    if (_isProcessing || _processingTimer != null) return;

    _processingTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_taskQueue.isEmpty) {
        _processingTimer?.cancel();
        _processingTimer = null;
        _isProcessing = false;
        return;
      }

      final task = _taskQueue.removeFirst();
      _isProcessing = true;

      Future.delayed(task.delay, () async {
        try {
          await task.operation();
        } catch (e) {
          debugPrint('Background task ${task.id} failed: $e');
        }
      });
    });
  }

  /// Memory-efficient lazy loading for lists
  Future<List<T>> loadItemsLazily<T>(
    Future<List<T>> Function(int offset, int limit) loader,
    int pageSize, {
    int maxConcurrentPages = 2,
  }) async {
    final loadedItems = <T>[];
    int currentPage = 0;
    bool hasMore = true;

    while (hasMore && loadedItems.length < pageSize * maxConcurrentPages) {
      final futures = <Future<List<T>>>[];

      for (int i = 0; i < maxConcurrentPages && hasMore; i++) {
        futures.add(loader(currentPage * pageSize, pageSize));
        currentPage++;
      }

      final results = await Future.wait(futures);
      for (final result in results) {
        loadedItems.addAll(result);
        if (result.length < pageSize) {
          hasMore = false;
          break;
        }
      }
    }

    return loadedItems.take(pageSize).toList();
  }

  /// Clean up resources
  void dispose() {
    _processingTimer?.cancel();
    _processingTimer = null;
    _pendingOperations.clear();
    _taskQueue.clear();
  }
}

class PerformanceTask {
  final String id;
  final Future<void> Function() operation;
  final Duration delay;

  PerformanceTask(this.id, this.operation, this.delay);
}
