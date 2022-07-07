import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/features/auth/data/datasources/local_token_datasource.dart';
import 'package:socnet/logic/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/logic/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_auth_token_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/logout_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/register_usecase.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate/bloc/auth_gate_bloc.dart';
import 'package:socnet/logic/features/comments/data/datasources/comment_network_datasource.dart';
import 'package:socnet/logic/features/comments/data/repositories/comment_repository_impl.dart';
import 'package:socnet/logic/features/comments/domain/usecases/add_comment.dart';
import 'package:socnet/logic/features/comments/presentation/comments_bloc/comments_bloc.dart';
import 'package:socnet/logic/features/posts/data/datasources/network_post_datasource.dart';
import 'package:socnet/logic/features/posts/data/repositories/post_repository_impl.dart';
import 'package:socnet/logic/features/posts/domain/usecases/create_post.dart';
import 'package:socnet/logic/features/posts/domain/usecases/delete_post.dart';
import 'package:socnet/logic/features/posts/domain/usecases/get_profile_posts.dart';
import 'package:socnet/logic/features/posts/domain/usecases/toggle_like.dart';
import 'package:socnet/logic/features/posts/presentation/post_bloc/post_bloc.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_bloc/post_creation_bloc.dart';
import 'package:socnet/logic/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/logic/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_follows.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_my_profile.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_profile.dart';
import 'package:socnet/logic/features/profile/domain/usecases/toggle_follow.dart';
import 'package:socnet/logic/features/profile/domain/usecases/update_avatar.dart';
import 'package:socnet/logic/features/profile/domain/usecases/update_profile.dart';
import 'package:socnet/logic/features/profile/presentation/my_profile/bloc/my_profile_bloc.dart';
import 'package:socnet/logic/features/profile/presentation/profile/bloc/profile_bloc.dart';

import './features/comments/domain/usecases/delete_comment.dart';
import './features/comments/domain/usecases/get_post_comments.dart';
import './features/comments/domain/usecases/toggle_like_on_comment.dart';

class UseCases {
  late final GetAuthTokenUseCase getAuthToken;
  late final LoginUseCase login;
  late final LogoutUsecase logout;
  late final RegisterUseCase register;

  late final GetFollows getFollows;
  late final GetMyProfile getMyProfile;
  late final GetProfile getProfile;
  late final UpdateProfile updateProfile;
  late final UpdateAvatar updateAvatar;
  late final ToggleFollow toggleFollow;

  late final CreatePost createPost;
  late final DeletePost deletePost;
  late final GetProfilePosts getProfilePosts;
  late final ToggleLike toggleLike;

  late final AddComment addComment;
  late final DeleteComment deleteComment;
  late final GetPostComments getPostComments;
  late final ToggleLikeOnComment toggleLikeOnComment;

  UseCases({
    required SharedPreferences sharedPrefs,
    required http.Client httpClient,
    required String apiHost,
    bool useHTTPS = true,
  }) {
    // auth
    final localAuthDS = LocalTokenDataSourceImpl(sharedPrefs);
    final netAuthDS = NetworkAuthDataSourceImpl(httpClient, apiHost, useHTTPS: useHTTPS);
    final authRepo = AuthRepositoryImpl(localAuthDS, netAuthDS);
    getAuthToken = GetAuthTokenUseCase(authRepo);
    login = LoginUseCase(authRepo);
    logout = LogoutUsecase(authRepo);
    register = RegisterUseCase(authRepo);
    // api facade
    final apiFacade = AuthenticatedAPIFacade(getAuthToken, httpClient, apiHost, useHTTPS: useHTTPS);
    // profiles
    final netProfileDS = ProfileNetworkDataSourceImpl(apiFacade);
    final profileRepo = ProfileRepositoryImpl(netProfileDS);
    getFollows = GetFollows(profileRepo);
    getMyProfile = GetMyProfile(profileRepo);
    getProfile = GetProfile(profileRepo);
    updateProfile = UpdateProfile(profileRepo);
    updateAvatar = UpdateAvatar(profileRepo);
    toggleFollow = ToggleFollow(profileRepo);
    // posts
    final netPostDS = NetworkPostDataSourceImpl(apiFacade);
    final postRepo = PostRepositoryImpl(netPostDS);
    createPost = CreatePost(postRepo);
    deletePost = DeletePost(postRepo);
    getProfilePosts = GetProfilePosts(postRepo);
    toggleLike = ToggleLike(postRepo);
    // comments
    final netCommentDS = CommentNetworkDataSourceImpl(apiFacade);
    final commentRepo = CommentRepositoryImpl(netCommentDS);
    addComment = AddComment(commentRepo);
    deleteComment = DeleteComment(commentRepo);
    getPostComments = GetPostComments(commentRepo);
    toggleLikeOnComment = ToggleLikeOnComment(commentRepo);
  }
}

final sl = GetIt.instance;

Future initialize() async {
  final usecases = UseCases(
    sharedPrefs: await SharedPreferences.getInstance(),
    httpClient: http.Client(),
    apiHost: realApiHost,
  );

  sl.registerLazySingleton(() => AuthGateBloc(usecases.getAuthToken, usecases.logout));
  sl.registerLazySingleton(() => ProfileBlocCreator(usecases.toggleFollow));
  sl.registerLazySingleton(() => PostBlocCreator(usecases.deletePost, usecases.toggleLike));

  sl.registerFactory(() => MyProfileBloc(usecases.getMyProfile, usecases.updateProfile, usecases.updateAvatar));
  sl.registerFactory(() => PostCreationBloc(usecases.createPost));
  sl.registerFactory(() => CommentsBloc(
        usecases.addComment,
        usecases.deleteComment,
        usecases.getPostComments,
        usecases.toggleLikeOnComment,
      ));
}