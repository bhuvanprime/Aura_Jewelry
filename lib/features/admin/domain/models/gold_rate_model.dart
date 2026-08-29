import 'package:equatable/equatable.dart';

/// Model representing Daily Live Precious Metal Rates
class GoldRateModel extends Equatable {
  final double gold24kPerGram;
  final double gold22kPerGram;
  final double gold18kPerGram;
  final double silverPerGram;
  final double dailyChangePercent;
  final bool isUp;
  final DateTime lastUpdated;

  const GoldRateModel({
    required this.gold24kPerGram,
    required this.gold22kPerGram,
    required this.gold18kPerGram,
    required this.silverPerGram,
    required this.dailyChangePercent,
    this.isUp = true,
    required this.lastUpdated,
  });

  /// Default starting market rate
  factory GoldRateModel.defaultRates() {
    return GoldRateModel(
      gold24kPerGram: 8550.0,
      gold22kPerGram: 7842.0,
      gold18kPerGram: 6415.0,
      silverPerGram: 98.50,
      dailyChangePercent: 0.6,
      isUp: true,
      lastUpdated: DateTime.now(),
    );
  }

  GoldRateModel copyWith({
    double? gold24kPerGram,
    double? gold22kPerGram,
    double? gold18kPerGram,
    double? silverPerGram,
    double? dailyChangePercent,
    bool? isUp,
    DateTime? lastUpdated,
  }) {
    return GoldRateModel(
      gold24kPerGram: gold24kPerGram ?? this.gold24kPerGram,
      gold22kPerGram: gold22kPerGram ?? this.gold22kPerGram,
      gold18kPerGram: gold18kPerGram ?? this.gold18kPerGram,
      silverPerGram: silverPerGram ?? this.silverPerGram,
      dailyChangePercent: dailyChangePercent ?? this.dailyChangePercent,
      isUp: isUp ?? this.isUp,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory GoldRateModel.fromJson(Map<String, dynamic> json) {
    return GoldRateModel(
      gold24kPerGram: (json['gold24kPerGram'] ?? 8550.0).toDouble(),
      gold22kPerGram: (json['gold22kPerGram'] ?? 7842.0).toDouble(),
      gold18kPerGram: (json['gold18kPerGram'] ?? 6415.0).toDouble(),
      silverPerGram: (json['silverPerGram'] ?? 98.50).toDouble(),
      dailyChangePercent: (json['dailyChangePercent'] ?? 0.6).toDouble(),
      isUp: json['isUp'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gold24kPerGram': gold24kPerGram,
      'gold22kPerGram': gold22kPerGram,
      'gold18kPerGram': gold18kPerGram,
      'silverPerGram': silverPerGram,
      'dailyChangePercent': dailyChangePercent,
      'isUp': isUp,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        gold24kPerGram,
        gold22kPerGram,
        gold18kPerGram,
        silverPerGram,
        dailyChangePercent,
        isUp,
        lastUpdated,
      ];
}
