@Tags(["end-to-end"])

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/logic/core/debug.dart';
import 'package:socnet/logic/di.dart' as di;
import 'package:socnet/logic/features/comments/domain/values/new_comment_value.dart';
import 'package:socnet/logic/features/posts/domain/values/new_post_value.dart';
import 'package:socnet/logic/features/profile/domain/entities/profile.dart';
import 'package:socnet/logic/features/profile/domain/values/profile_update.dart';

import '../shared/fixtures/fixture_reader.dart';
import '../shared/helpers/helpers.dart';
import 'backend.dart';

void assertTimeAroundNow(DateTime time) {
  expect(time.difference(DateTime.now()).inSeconds.abs(), lessThan(30));
}

const apiHost = "localhost:4242";

void main() {
  late Backend backend;
  late di.UseCases usecases;
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });
  setUp(() async {
    backend = Backend();
    await backend.setUp();
    SharedPreferences.setMockInitialValues({});
    usecases = di.UseCases(
      sharedPrefs: RxSharedPreferences.getInstance(),
      httpClient: http.Client(),
      apiHost: apiHost,
      useHTTPS: false,
    );
  });
  tearDown(() async {
    await backend.tearDown();
  });

  test("happy path", () async {
    printDebug("register a user");
    forceRight(await usecases.register("sam", "secure_pass"));
    printDebug("try to login with the same credentials");
    forceRight(await usecases.login("sam", "secure_pass"));

    printDebug("get my profile");
    final profile1 = forceRight(await usecases.getMyProfile());
    expect(profile1.username, "sam");
    expect(profile1.isMine, true);
    expect(profile1.isFollowed, false);
    expect(profile1.follows, 0);
    expect(profile1.followers, 0);

    printDebug("logout");
    forceRight(await usecases.logout());

    printDebug("register another user");
    forceRight(await usecases.register("test", "pass12345"));
    final profile2 = forceRight(await usecases.getMyProfile());
    expect(profile2.username, "test");

    printDebug("get first profile, viewing from second user");
    final gotProfile1 = forceRight(await usecases.getProfile(profile1.id));
    final wantProfile1 = Profile(
      id: profile1.id,
      username: profile1.username,
      about: profile1.about,
      avatarUrl: profile1.avatarUrl,
      followers: profile1.followers,
      follows: profile1.follows,
      isMine: false, // important part
      isFollowed: profile1.isFollowed,
    );
    expect(gotProfile1, wantProfile1);

    printDebug("follow first user from second user");
    forceRight(await usecases.toggleFollow(gotProfile1));

    printDebug("assert it was followed");
    final wantProfile1Followed = Profile(
      id: profile1.id,
      username: profile1.username,
      about: profile1.about,
      avatarUrl: profile1.avatarUrl,
      follows: profile1.follows,
      followers: 1,
      isMine: false,
      isFollowed: true,
    );
    final gotProfile1Followed = forceRight(await usecases.getProfile(profile1.id));
    expect(gotProfile1Followed, wantProfile1Followed);

    final gotProfile2AfterFollowing = forceRight(await usecases.getMyProfile());
    expect(gotProfile2AfterFollowing.follows, 1);

    printDebug("get follows of second profile");
    final profile2Follows = forceRight(await usecases.getFollows(gotProfile2AfterFollowing));
    expect(profile2Follows.length, 1);
    expect(profile2Follows[0], wantProfile1Followed);

    printDebug("update about");
    final updatedProfile2 = forceRight(await usecases.updateProfile(ProfileUpdate(newAbout: "New About")));
    expect(updatedProfile2.about, "New About");

    printDebug("update avatar");
    final newAvatar = fileFixture("avatar.png");
    final newURL = forceRight(await usecases.updateAvatar(newAvatar));
    final avatarFromStatic = backend.getStaticFile(newURL);
    expect(avatarFromStatic.readAsBytesSync(), File(newAvatar.path).readAsBytesSync());

    printDebug(
        "create post without images"); // just to test that api returns an adequate response for a post without images
    const newPostWithoutImages = NewPostValue(images: [], text: "Post without images");
    forceRight(await usecases.createPost(newPostWithoutImages));
    final posts = forceRight(await usecases.getProfilePosts(updatedProfile2));
    expect(posts.length, 1);
    expect(posts[0].text, newPostWithoutImages.text);

    printDebug("delete post without images");
    forceRight(await usecases.deletePost(posts[0]));

    printDebug("create post");
    final postImages = [
      fileFixture("avatar.png"),
      fileFixture("avatar.png"),
    ];
    final newPost = NewPostValue(images: postImages, text: "The First Post");
    forceRight(await usecases.createPost(newPost));
    final postsNow = forceRight(await usecases.getProfilePosts(updatedProfile2));
    expect(postsNow.length, 1);
    final createdPost = postsNow[0];
    expect(createdPost.isMine, true);
    expect(createdPost.author.id, profile2.id);
    expect(createdPost.text, "The First Post");
    expect(createdPost.isLiked, false);
    assertTimeAroundNow(createdPost.createdAt);
    expect(createdPost.images.length, 2);
    final firstStaticImage = createdPost.images[0].url;
    final secondStaticImage = createdPost.images[1].url;
    expect(backend.getStaticFile(firstStaticImage).readAsBytesSync(), File(postImages[0].path).readAsBytesSync());
    expect(backend.getStaticFile(secondStaticImage).readAsBytesSync(), File(postImages[1].path).readAsBytesSync());
    expect(createdPost.isLiked, false);
    expect(createdPost.likes, 0);

    printDebug("login from the first user");
    forceRight(await usecases.logout());
    forceRight(await usecases.login("sam", "secure_pass"));

    printDebug("get posts of the second user");
    final postsAsProfile1 = forceRight(await usecases.getProfilePosts(updatedProfile2));
    expect(postsAsProfile1.length, 1);
    final post = postsAsProfile1[0];

    printDebug("assert it is not liked and isMine = false");
    expect(post.isMine, false);
    expect(post.isLiked, false);
    expect(post.likes, 0);

    printDebug("like the post");
    forceRight(await usecases.toggleLike(post));

    printDebug("assert it is now liked");
    final postLiked = forceRight(await usecases.getProfilePosts(updatedProfile2))[0];
    expect(postLiked.isLiked, true);
    expect(postLiked.likes, 1);

    printDebug("assert there is now 0 comments for this post");
    final comments = forceRight(await usecases.getPostComments(postLiked));
    expect(comments.length, 0);

    printDebug("add a comment");
    const newComment = NewCommentValue(text: "A new comment");
    final createdComment = forceRight(await usecases.addComment(postLiked, newComment));
    assertTimeAroundNow(createdComment.createdAt);
    expect(createdComment.text, newComment.text);
    expect(createdComment.isMine, true);
    final profile1Now = forceRight(await usecases.getMyProfile());
    expect(createdComment.author, profile1Now);

    printDebug("like it from second profile");
    forceRight(await usecases.logout());
    forceRight(await usecases.login("test", "pass12345"));
    final postComments = forceRight(await usecases.getPostComments(postLiked));
    expect(postComments.length, 1);
    final notLikedComment = postComments[0];
    expect(notLikedComment.isMine, false); // since you're now logged in as the second profile
    expect(notLikedComment.likes, 0);
    expect(notLikedComment.isLiked, false);
    forceRight(await usecases.toggleLikeOnComment(notLikedComment));

    printDebug("assert it was liked");
    final postCommentsNow = forceRight(await usecases.getPostComments(postLiked));
    expect(postCommentsNow.length, 1);
    final likedComment = postCommentsNow[0];
    expect(likedComment.isLiked, true);
    expect(likedComment.likes, 1);

    printDebug("login as first profile");
    forceRight(await usecases.login("sam", "secure_pass"));

    printDebug("delete this comment");
    forceRight(await usecases.deleteComment(likedComment));
    printDebug("assert it was deleted");
    final commentsAfterDeletion = forceRight(await usecases.getPostComments(postLiked));
    expect(commentsAfterDeletion.length, 0);

    printDebug("login as second profile");
    forceRight(await usecases.login("test", "pass12345"));

    printDebug("delete the post");
    forceRight(await usecases.deletePost(postLiked));

    printDebug("assert the post was deleted");
    final postsAfterDeletion = forceRight(await usecases.getProfilePosts(updatedProfile2));
    expect(postsAfterDeletion.length, 0);
  });
}

Future<SharedPreferences> _getSharedPrefs() {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
