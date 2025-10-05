import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for managing viral growth features: referrals, reviews, and sharing
class ViralGrowthService {
  final InAppReview _inAppReview = InAppReview.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _referralCodeKey = 'user_referral_code';
  static const String _reviewRequestCountKey = 'review_request_count';
  static const String _lastReviewRequestKey = 'last_review_request';
  static const String _referralCountKey = 'referral_count';

  /// Generate or retrieve user's referral code
  Future<String> getReferralCode() async {
    String? code = await _storage.read(key: _referralCodeKey);
    if (code == null || code.isEmpty) {
      code = _generateReferralCode();
      await _storage.write(key: _referralCodeKey, value: code);
    }
    return code;
  }

  /// Generate a unique 6-character referral code
  String _generateReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Share the app with a referral link
  Future<void> shareApp({String? customMessage}) async {
    final referralCode = await getReferralCode();
    final message = customMessage ??
        '🎓 Check out Pocket Lawyer - AI Legal Assistant!\n\n'
        '✓ Instant legal guidance\n'
        '✓ 8M+ court cases\n'
        '✓ 500K+ state bills\n'
        '✓ AI-powered analysis\n\n'
        'Use my referral code: $referralCode\n'
        'Download: https://play.google.com/store/apps/details?id=ai.pocketlawyer.app';

    await Share.share(
      message,
      subject: 'Try Pocket Lawyer - AI Legal Assistant',
    );

    // Track share event
    await _incrementShareCount();
  }

  /// Share specific content (e.g., legal advice or case)
  Future<void> shareContent({
    required String title,
    required String content,
  }) async {
    final message = '$title\n\n$content\n\n'
        'Powered by Pocket Lawyer - AI Legal Assistant\n'
        'https://play.google.com/store/apps/details?id=ai.pocketlawyer.app';

    await Share.share(message, subject: title);
  }

  /// Request app store review (smart timing)
  Future<void> requestReview({bool force = false}) async {
    if (!force) {
      // Check if we should show review prompt
      final shouldShow = await _shouldShowReviewPrompt();
      if (!shouldShow) return;
    }

    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
      await _updateReviewRequestTracking();
    }
  }

  /// Open app store for manual review
  Future<void> openAppStore() async {
    await _inAppReview.openStoreListing(
      appStoreId: 'ai.pocketlawyer.app', // Will be updated with actual ID
    );
  }

  /// Check if we should show review prompt (smart timing)
  Future<bool> _shouldShowReviewPrompt() async {
    try {
      // Get last request timestamp
      final lastRequestStr = await _storage.read(key: _lastReviewRequestKey);
      if (lastRequestStr != null) {
        final lastRequest = DateTime.parse(lastRequestStr);
        final daysSinceLastRequest = DateTime.now().difference(lastRequest).inDays;

        // Don't show if requested in last 30 days
        if (daysSinceLastRequest < 30) return false;
      }

      // Get request count
      final countStr = await _storage.read(key: _reviewRequestCountKey);
      final count = int.tryParse(countStr ?? '0') ?? 0;

      // Don't show more than 3 times total
      if (count >= 3) return false;

      return true;
    } catch (e) {
      return true;
    }
  }

  /// Update review request tracking
  Future<void> _updateReviewRequestTracking() async {
    final now = DateTime.now().toIso8601String();
    await _storage.write(key: _lastReviewRequestKey, value: now);

    final countStr = await _storage.read(key: _reviewRequestCountKey);
    final count = (int.tryParse(countStr ?? '0') ?? 0) + 1;
    await _storage.write(key: _reviewRequestCountKey, value: count.toString());
  }

  /// Increment share count for analytics
  Future<void> _incrementShareCount() async {
    final countStr = await _storage.read(key: 'share_count');
    final count = (int.tryParse(countStr ?? '0') ?? 0) + 1;
    await _storage.write(key: 'share_count', value: count.toString());
  }

  /// Track referral usage
  Future<void> trackReferralUsage(String referralCode) async {
    await _storage.write(key: 'used_referral_code', value: referralCode);
  }

  /// Get referral statistics
  Future<Map<String, int>> getReferralStats() async {
    final shareCountStr = await _storage.read(key: 'share_count');
    final referralCountStr = await _storage.read(key: _referralCountKey);

    return {
      'shares': int.tryParse(shareCountStr ?? '0') ?? 0,
      'referrals': int.tryParse(referralCountStr ?? '0') ?? 0,
    };
  }

  /// Open social media for sharing
  Future<void> shareOnSocialMedia(String platform) async {
    final referralCode = await getReferralCode();
    String url = '';

    switch (platform.toLowerCase()) {
      case 'twitter':
        final text = Uri.encodeComponent(
          '🎓 Just discovered Pocket Lawyer - AI Legal Assistant! '
          'Get instant legal guidance with AI. Use code: $referralCode',
        );
        url = 'https://twitter.com/intent/tweet?text=$text&url=https://play.google.com/store/apps/details?id=ai.pocketlawyer.app';
        break;
      case 'facebook':
        url = 'https://www.facebook.com/sharer/sharer.php?u=https://play.google.com/store/apps/details?id=ai.pocketlawyer.app';
        break;
      case 'linkedin':
        url = 'https://www.linkedin.com/sharing/share-offsite/?url=https://play.google.com/store/apps/details?id=ai.pocketlawyer.app';
        break;
      default:
        await shareApp();
        return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Show success dialog after sharing
  void showShareSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Color(0xFF5D5CDE)),
            SizedBox(width: 8),
            Text('Thank You!'),
          ],
        ),
        content: const Text(
          'Thanks for spreading the word about Pocket Lawyer! '
          'Every share helps us make legal assistance more accessible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show referral reward dialog
  void showReferralRewardDialog(BuildContext context, int rewardDays) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.green),
            SizedBox(width: 8),
            Text('Referral Reward!'),
          ],
        ),
        content: Text(
          'You\'ve earned $rewardDays days of Pro access for referring a friend!\n\n'
          'Keep sharing to unlock more benefits.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }
}
