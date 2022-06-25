const apiHost = "socio.skomarov.com";

String registerEndpoint() {
  return "/auth/register";
}

String loginEndpoint() {
  return "/auth/login";
}

String addPostCommentEndpoint(String postId) {
  return "/api/comments/?post_id=$postId";
}

String deleteCommentEndpoint(String commentId) {
  return ""; // unimplemented
}

String getPostCommentsEndpoint(String postId) {
  return "/api/comments/?post_id=$postId";
}

String toggleLikeOnCommentEndpoint(String commentId) {
  return "/api/comments/$commentId/toggle-like";
}

String feedEndpoint(int postAmount) {
  return ""; // unimplemented
}

String createPostEndpoint() {
  return "/api/posts";
}

String deletePostEndpoint(String postId) {
  return "/api/posts/$postId";
}

String getProfilePostsEndpoint(String profileId) {
  return "/api/posts/?profile_id=$profileId";
}

String toggleLikeOnPostEndpoint(String postId) {
  return "/api/posts/$postId/toggle-like";
}

String getFollowsEndpoint(String profileId) {
  return "/api/profiles/$profileId/follows";
}

String getMyProfileEndpoint() {
  return "/api/profiles/me";
}

String updateProfileEndpoint() {
  return "/api/profiles/me";
}

String updateAvatarEndpoint() {
  return "/api/profiles/me/avatar";
}

String toggleFollowEndpoint(String targetProfileId) {
  return "/api/profiles/$targetProfileId/toggle-follow";
}
