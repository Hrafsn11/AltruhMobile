class Campaign {
  final int? id;
  final String title;
  final String description;
  final String imageUrl;
  final int targetAmount;
  final int collectedAmount;
  final String type;
  final String creatorName;
  final String displayTarget;
  final String displayCollected;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.targetAmount,
    required this.collectedAmount,
    required this.type,
    required this.creatorName,
    required this.displayTarget,
    required this.displayCollected,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    // Handle image URL (pakai 'gambar_url' dari API, bisa null)
    String imageUrl = '';
    if (json['gambar_url'] != null &&
        json['gambar_url'].toString().isNotEmpty) {
      imageUrl = json['gambar_url'];
    }
    // Handle creator name
    String creatorName = '';
    if (json['user'] != null && json['user']['name'] != null) {
      creatorName = json['user']['name'];
    } else if (json['creator_name'] != null) {
      creatorName = json['creator_name'];
    }
    // Handle target/collected by type
    int target = 1;
    int collected = 0;
    switch (json['type']) {
      case 'financial':
        target = double.tryParse(json['target_amount']?.toString() ?? '1')
                ?.toInt() ??
            1;
        collected = double.tryParse(json['collected_amount']?.toString() ?? '0')
                ?.toInt() ??
            0;
        break;
      case 'goods':
        target = int.tryParse(json['target_items']?.toString() ?? '1') ?? 1;
        collected =
            int.tryParse(json['collected_items']?.toString() ?? '0') ?? 0;
        break;
      case 'emotional':
        target = int.tryParse(json['target_sessions']?.toString() ?? '1') ?? 1;
        collected =
            int.tryParse(json['collected_sessions']?.toString() ?? '0') ?? 0;
        break;
    }
    // Ambil displayTarget dan displayCollected dari API
    String displayTarget = json['display_target'] ?? target.toString();
    String displayCollected = json['display_collected'] ?? collected.toString();
    return Campaign(
      id: json['id'],
      title: json['title'] ?? '-',
      description: json['description'] ?? '-',
      imageUrl: imageUrl,
      targetAmount: target,
      collectedAmount: collected,
      type: json['type'] ?? '-',
      creatorName: creatorName,
      displayTarget: displayTarget,
      displayCollected: displayCollected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
    };
  }

  double get progress => targetAmount == 0 ? 0 : collectedAmount / targetAmount;
}
