import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/comments/domain/usecases/get_post_comments_usecase.dart';
import 'package:socnet/logic/features/comments/presentation/comments_cubit/comments_cubit.dart';
import 'package:socnet/logic/features/posts/domain/entities/post.dart';
import 'package:socnet/ui/theme.dart';
import 'package:socnet/ui/widgets/author_widget.dart';
import 'package:socnet/ui/widgets/simple_future_builder.dart';

import '../../logic/di.dart';
import '../../logic/features/comments/domain/entities/comment.dart';

class CommentsPage extends StatelessWidget {
  final Post post;
  const CommentsPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SimpleFutureBuilder<List<Comment>>(
        future: sl<GetPostCommentsUseCase>()(post),
        loading: CircularProgressIndicator(),
        loadedBuilder: (initComments) => BlocProvider<CommentsCubit>(
          create: (_) => sl<CommentsCubitFactory>()(post, initComments),
          child: BlocBuilder<CommentsCubit, CommentsState>(
            builder: (context, state) => ListView(children: [
              ...state.comments.map(
                (comment) => CommentWidget(comment: comment),
              ),
              TextField(
                decoration: inputDecoration,
                onSubmitted: (text) => context.read<CommentsCubit>().addComment(text),
              )
            ]),
          ),
        ),
        failureBuilder: (failure) => Text(failure.toString()),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;
  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthorWidget(author: comment.author),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 70),
                child: Text(comment.text, style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
          Spacer(),
          Column(children: [
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: comment.isMine ? null : () => context.read<CommentsCubit>().likePressed(comment),
            ),
            Text(comment.likes.toString(), style: TextStyle(fontSize: 20)),
          ]),
        ],
      ),
    );
  }
}
