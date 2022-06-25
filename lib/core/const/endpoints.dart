const apiHost = "instagram.skomarov.com";


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
  // throw UnimplementedError();
  return "";
}
String getPostCommentsEndpoint(String postId) {
  return "/api/comments/?post_id=$postId";
}
String toggleLikeOnCommentEndpoint(String commentId) {
  return "/api/comments/$commentId/toggle-like";
}

String feedEndpoint(int postAmount) {
  // throw UnimplementedError();
  return "";
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
String toggleFollowEndpoint(String targetProfileId) {
  return "/api/profiles/$targetProfileId/toggle-follow";
}

