class UserProgress {
  UserProgress({
    this.lastEpId,
  });

  int? lastEpId;

  UserProgress.fromJson(Map<String, dynamic> json) {
    lastEpId = json['last_ep_id'];
  }

  Map<String, dynamic> toJson() => {'last_ep_id': lastEpId};
}
