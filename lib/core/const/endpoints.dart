import 'package:equatable/equatable.dart';

const realApiHost = "socio.skomarov.com";

class EndpointQuery extends Equatable {
  final String endpoint;
  final Map<String, dynamic> query;
  @override
  List get props => [endpoint, query];

  const EndpointQuery(this.endpoint, [this.query = const <String, dynamic>{}]);

  Uri toURL(String host, bool useHTTPS) =>
      useHTTPS ? Uri.https(host, endpoint, query) : Uri.http(host, endpoint, query);
}

EndpointQuery registerEndpoint() {
  return const EndpointQuery("/auth/register");
}

EndpointQuery loginEndpoint() {
  return const EndpointQuery("/auth/login");
}

EndpointQuery addPostCommentEndpoint(String postId) {
  return EndpointQuery("/api/comments", {"post_id": postId});
}

EndpointQuery deleteCommentEndpoint(String commentId) {
  return const EndpointQuery("unimplemented");
}

EndpointQuery getPostCommentsEndpoint(String postId) {
  return EndpointQuery("api/comments/", {"post_id": postId});
}

EndpointQuery toggleLikeOnCommentEndpoint(String commentId) {
  return EndpointQuery("/api/comments/$commentId/toggle-like");
}

EndpointQuery feedEndpoint(int postAmount) {
  return const EndpointQuery("unimplemented");
}

EndpointQuery createPostEndpoint() {
  return const EndpointQuery("/api/posts");
}

EndpointQuery deletePostEndpoint(String postId) {
  return EndpointQuery("/api/posts/$postId");
}

EndpointQuery getProfilePostsEndpoint(String profileId) {
  return EndpointQuery("api/posts/", {"profile_id": profileId});
}

EndpointQuery toggleLikeOnPostEndpoint(String postId) {
  return EndpointQuery("/api/posts/$postId/toggle-like");
}

EndpointQuery getFollowsEndpoint(String profileId) {
  return EndpointQuery("api/profiles/$profileId/follows");
}

EndpointQuery getMyProfileEndpoint() {
  return const EndpointQuery("api/profiles/me");
}

EndpointQuery getProfileEndpoint(String id) {
  return EndpointQuery("/api/profiles/$id");
}

EndpointQuery updateProfileEndpoint() {
  return const EndpointQuery("api/profiles/me");
}

EndpointQuery updateAvatarEndpoint() {
  return const EndpointQuery("/api/profiles/me/avatar");
}

EndpointQuery toggleFollowEndpoint(String targetProfileId) {
  return EndpointQuery("/api/profiles/$targetProfileId/toggle-follow");
}
