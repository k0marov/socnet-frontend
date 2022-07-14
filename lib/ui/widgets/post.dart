import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/posts/presentation/post_cubit/post_cubit.dart';

import '../../logic/di.dart';
import '../../logic/features/posts/domain/entities/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width;
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
                      child: Row(children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: state.post.author.avatarUrl.fold(
                            () => Icon(Icons.person),
                            (avatar) => CircleAvatar(foregroundImage: NetworkImage("https://" + avatar)),
                          ),
                        ),
                        Text("@" + state.post.author.username),
                        if (state.post.isMine)
                          TextButton(
                              onPressed: () => context.read<PostCubit>().deletePressed(), child: Text("Delete!")),
                        Spacer(),
                        Text("On " + state.post.createdAt.toLocal().toString()),
                      ]),
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
                                itemBuilder: (context, index) => Image.network(
                                  fit: BoxFit.fill,
                                  width: imageSize,
                                  height: imageSize,
                                  "https://" + state.post.images[index].url,
                                ),
                              )
                            : Image.network(
                                fit: BoxFit.fill,
                                width: imageSize,
                                height: imageSize,
                                "https://" + state.post.images.first.url,
                              ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                      child: Text(
                        state.post.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        Column(children: [
                          Icon(Icons.favorite, color: Colors.red, size: 50),
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
                              onPressed: () {},
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
