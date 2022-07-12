import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:socnet/logic/core/authenticated_api_facade.dart';
import 'package:socnet/logic/core/const/endpoints.dart';
import 'package:socnet/logic/features/auth/data/datasources/local_token_datasource.dart';
import 'package:socnet/logic/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/logic/features/auth/data/mappers/token_mapper.dart';
import 'package:socnet/logic/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_auth_token_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/get_token_stream_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/logout_usecase.dart';
import 'package:socnet/logic/features/auth/domain/usecases/register_usecase.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/failure_handler.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/failure_handler.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/register_cubit.dart';
import 'package:socnet/logic/features/comments/data/datasources/comment_network_datasource.dart';
import 'package:socnet/logic/features/comments/data/mappers/comment_mapper.dart';
import 'package:socnet/logic/features/comments/data/repositories/comment_repository_impl.dart';
import 'package:socnet/logic/features/comments/domain/usecases/add_comment_usecase.dart';
import 'package:socnet/logic/features/comments/presentation/comments_cubit/comments_cubit.dart';
import 'package:socnet/logic/features/posts/data/datasources/network_post_datasource.dart';
import 'package:socnet/logic/features/posts/data/mappers/post_mapper.dart';
import 'package:socnet/logic/features/posts/data/repositories/post_repository_impl.dart';
import 'package:socnet/logic/features/posts/domain/usecases/create_post_usecase.dart';
import 'package:socnet/logic/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:socnet/logic/features/posts/domain/usecases/get_profile_posts_usecase.dart';
import 'package:socnet/logic/features/posts/domain/usecases/toggle_like_on_post_usecase.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_cubit/failure_handler.dart';
import 'package:socnet/logic/features/posts/presentation/post_creation_cubit/post_creation_cubit.dart';
import 'package:socnet/logic/features/posts/presentation/post_cubit/post_cubit.dart';
import 'package:socnet/logic/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/logic/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_follows_usecase.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:socnet/logic/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:socnet/logic/features/profile/domain/usecases/toggle_follow_usecase.dart';
import 'package:socnet/logic/features/profile/domain/usecases/update_avatar_usecase.dart';
import 'package:socnet/logic/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:socnet/logic/features/profile/presentation/my_profile_cubit/my_profile_cubit.dart';
import 'package:socnet/logic/features/profile/presentation/profile_cubit/profile_cubit.dart';

import './features/comments/domain/usecases/delete_comment_usecase.dart';
import './features/comments/domain/usecases/get_post_comments_usecase.dart';
import './features/comments/domain/usecases/toggle_like_on_comment_usecase.dart';
import 'features/auth/presentation/auth_gate_cubit/auth_gate_cubit.dart';

class UseCases {
  late final GetAuthTokenUseCase getAuthToken;
  late final GetTokenStreamUseCase getTokenStream;
  late final LoginUseCase login;
  late final LogoutUseCase logout;
  late final RegisterUseCase register;

  late final GetFollowsUseCase getFollows;
  late final GetMyProfileUseCase getMyProfile;
  late final GetProfileUseCase getProfile;
  late final UpdateProfileUseCase updateProfile;
  late final UpdateAvatarUseCase updateAvatar;
  late final ToggleFollowUseCase toggleFollow;

  late final CreatePostUseCase createPost;
  late final DeletePostUseCase deletePost;
  late final GetProfilePostsUseCase getProfilePosts;
  late final ToggleLikeOnPostUseCase toggleLike;

  late final AddCommentUseCase addComment;
  late final DeleteCommentUseCase deleteComment;
  late final GetPostCommentsUseCase getPostComments;
  late final ToggleLikeOnCommentUseCase toggleLikeOnComment;

  UseCases({
    required RxSharedPreferences sharedPrefs,
    required http.Client httpClient,
    required String apiHost,
    bool useHTTPS = true,
  }) {
    // auth
    final localAuthDS = LocalTokenDataSourceImpl(sharedPrefs);
    final netAuthDS = NetworkAuthDataSourceImpl(TokenMapperImpl(), httpClient, apiHost, useHTTPS: useHTTPS);
    final authRepo = AuthRepositoryImpl(localAuthDS, netAuthDS);
    getAuthToken = newGetAuthTokenUseCase(authRepo);
    getTokenStream = newGetTokenStreamUseCase(authRepo);
    login = newLoginUseCase(authRepo);
    logout = newLogoutUseCase(authRepo);
    register = newRegisterUseCase(authRepo);
    // api facade
    final apiFacade = AuthenticatedAPIFacade(getAuthToken, httpClient, apiHost, useHTTPS: useHTTPS);
    // profiles
    final netProfileDS = ProfileNetworkDataSourceImpl(apiFacade);
    final profileRepo = ProfileRepositoryImpl(netProfileDS);
    getFollows = newGetFollowsUseCase(profileRepo);
    getMyProfile = newGetMyProfileUseCase(profileRepo);
    getProfile = newGetProfileUseCase(profileRepo);
    updateProfile = newUpdateProfileUseCase(profileRepo);
    updateAvatar = newUpdateAvatarUseCase(profileRepo);
    toggleFollow = newToggleFollowUseCase(profileRepo);
    // posts
    final netPostDS = NetworkPostDataSourceImpl(PostMapperImpl(), apiFacade);
    final postRepo = PostRepositoryImpl(netPostDS);
    createPost = newCreatePostUseCase(postRepo);
    deletePost = newDeletePostUseCase(postRepo);
    getProfilePosts = newGetProfilePostsUseCase(postRepo);
    toggleLike = newToggleLikeOnPostUseCase(postRepo);
    // comments
    final netCommentDS = CommentNetworkDataSourceImpl(CommentMapperImpl(), apiFacade);
    final commentRepo = CommentRepositoryImpl(netCommentDS);
    addComment = newAddCommentUseCase(commentRepo);
    deleteComment = newDeleteCommentUseCase(commentRepo);
    getPostComments = newGetPostCommentsUseCase(commentRepo);
    toggleLikeOnComment = newToggleLikeOnCommentUseCase(commentRepo);
  }
}

final sl = GetIt.instance;

Future initialize() async {
  final usecases = UseCases(
    sharedPrefs: RxSharedPreferences.getInstance(),
    httpClient: http.Client(),
    apiHost: realApiHost,
  );

  sl.registerLazySingleton(() => usecases.getMyProfile);
  sl.registerLazySingleton(() => usecases.logout);

  sl.registerLazySingleton(() => profileCubitFactoryImpl(usecases.toggleFollow));
  sl.registerLazySingleton(() => myProfileCubitFactoryImpl(usecases.updateProfile, usecases.updateAvatar));
  sl.registerLazySingleton(() => postCubitFactoryImpl(usecases.toggleLike, usecases.deletePost));
  sl.registerLazySingleton(() => commentsCubitFactoryImpl(
        usecases.addComment,
        usecases.deleteComment,
        usecases.toggleLikeOnComment,
      ));
  sl.registerLazySingleton(() => postCreationCubitFactoryImpl(usecases.createPost, postCreationFailureHandlerImpl));

  sl.registerFactory(() => AuthGateCubit(usecases.getTokenStream));
  sl.registerFactory(() => LoginCubit(usecases.login, loginFailureHandlerImpl));
  sl.registerFactory(() => RegisterCubit(passStrengthGetterImpl, usecases.register, registerFailureHandlerImpl));
}
