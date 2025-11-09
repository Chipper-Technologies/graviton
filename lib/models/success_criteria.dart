/// Success criteria for objectives
class SuccessCriteria {
  final double stabilityThreshold;
  final int minimumTime;
  final int allowedCollisions;

  const SuccessCriteria({
    required this.stabilityThreshold,
    required this.minimumTime,
    required this.allowedCollisions,
  });

  factory SuccessCriteria.fromJson(Map<String, dynamic> json) {
    return SuccessCriteria(
      stabilityThreshold: json['stabilityThreshold'] as double,
      minimumTime: json['minimumTime'] as int,
      allowedCollisions: json['allowedCollisions'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stabilityThreshold': stabilityThreshold,
      'minimumTime': minimumTime,
      'allowedCollisions': allowedCollisions,
    };
  }
}
