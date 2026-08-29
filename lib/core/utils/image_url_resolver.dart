/// Utility to automatically format and resolve image URLs from social media
/// (Instagram public post links, Pinterest, Imgur, Cloudinary, and direct web URLs).
class ImageUrlResolver {
  ImageUrlResolver._();

  /// Resolves any web link or social media post URL into a direct loadable image URL.
  static String resolve(String rawUrl) {
    var url = rawUrl.trim();
    if (url.isEmpty) return url;

    // 1. Instagram Public Post / Reel URL converter
    // Example: https://www.instagram.com/p/DF4a5_xyz/?igsh=...
    // Resolves to: https://www.instagram.com/p/DF4a5_xyz/media/?size=l
    if (url.contains('instagram.com/p/') || url.contains('instagram.com/reel/')) {
      try {
        final uri = Uri.parse(url);
        final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
        final pIndex = segments.indexWhere((s) => s == 'p' || s == 'reel');

        if (pIndex != -1 && pIndex + 1 < segments.length) {
          final shortcode = segments[pIndex + 1];
          return 'https://www.instagram.com/p/$shortcode/media/?size=l';
        }
      } catch (_) {
        // Return original if parse fails
      }
    }

    // 2. Imgur Page to Direct Image
    // Example: https://imgur.com/gallery/abc1234 or https://imgur.com/abc1234
    if (url.contains('imgur.com/') && !url.contains('i.imgur.com') && !url.endsWith('.jpg') && !url.endsWith('.png')) {
      try {
        final uri = Uri.parse(url);
        final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
        if (segments.isNotEmpty) {
          final id = segments.last;
          return 'https://i.imgur.com/$id.jpg';
        }
      } catch (_) {}
    }

    // 3. Pinterest Pin
    // Returns as-is or direct CDN if provided

    return url;
  }

  /// Validates if the resolved link is a valid web URL format
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    final clean = url.trim().toLowerCase();
    return clean.startsWith('http://') || clean.startsWith('https://');
  }
}
