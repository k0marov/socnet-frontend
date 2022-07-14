import 'package:card_swiper/card_swiper.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/posts/presentation/post_cubit/post_cubit.dart';
import 'package:socnet/ui/helpers.dart';
import 'package:socnet/ui/pages/comments_page.dart';
import 'package:socnet/ui/widgets/author_widget.dart';
import 'package:socnet/ui/widgets/date_text_widget.dart';

import '../../logic/di.dart';
import '../../logic/features/posts/domain/entities/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width;
    Widget getImage(PostState state, int index) => Image.network(
          fit: BoxFit.fill,
          width: imageSize,
          height: imageSize,
          "https://" + state.post.images[index].url,
        );
    return BlocProvider<PostCubit>(
      create: (_) => sl<PostCubitFactory>()(post),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) => state.isDeleted
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          AuthorWidget(author: state.post.author),
                          if (state.post.isMine)
                            TextButton(
                              onPressed: () => context.read<PostCubit>().deletePressed(),
                              child: Text("Delete!"),
                            ),
                          Spacer(),
                          DateTextWidget(date: state.post.createdAt.toLocal()),
                        ]),
                      ),
                    ),
                    if (state.post.images.isNotEmpty)
                      SizedBox(
                        height: imageSize,
                        child: state.post.images.length > 1
                            ? Swiper(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.post.images.length,
                                pagination: SwiperPagination(),
                                control: SwiperControl(),
                                itemBuilder: (context, index) => GestureDetector(
                                  onTap: () => openFullscreen(context, getImage(state, index)),
                                  child: getImage(state, index),
                                ),
                              )
                            : getImage(state, 0),
                      ),
                    if (state.post.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                        child: ExpandableText(
                          state.post.text,
                          maxLines: 3,
                          expandText: "more",
                          collapseText: "less",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        Column(children: [
                          IconButton(
                            icon: Icon(Icons.favorite, color: Colors.red),
                            iconSize: 50,
                            onPressed: state.post.isMine ? null : () => context.read<PostCubit>().likePressed(),
                          ),
                          Text((state.post.likes + 1).toString(), style: TextStyle(fontSize: 20)),
                        ]),
                        SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: Colors.grey.shade200,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () => pushPage(context, CommentsPage(post: state.post), true),
                              child: Center(child: Text("Comments")),
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
