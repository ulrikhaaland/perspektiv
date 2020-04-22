import 'package:flutter/material.dart';
import 'package:perspektiv/model/Comment.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/Category.dart';
import '../model/Review.dart';

class ReviewInput extends StatelessWidget {
  final Comment comment;
  final List<Comment> commentList;

  const ReviewInput({Key key, this.comment, this.commentList})
      : assert(comment != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Review review = Provider.of<Review>(context);

    assert(review != null);

    TextEditingController _textController = TextEditingController()
      ..text = comment.comment;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (comment.init != false) comment.init = false;
    });
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: TextField(
        minLines: 1,
        maxLines: 5,
        controller: _textController,
        onChanged: (val) {
          if (comment.init != false) comment.init = false;

          comment.comment = val;
        },
        autocorrect: false,
        autofocus: comment.init,
        style: TextStyle(
            color: colorTextGrey, fontStyle: FontStyle.italic, fontSize: 16),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
//          suffix: InkWell(
//            onTap: () {
//              commentList.remove(comment);
//              review.onAddCategory.notifyListeners();
//            },
//            child: Icon(
//              Icons.delete,
//              color: colorLove,
//            ),
//          ),
          hintStyle: TextStyle(color: colorTextGrey),
          hintText: comment.label,
          counterStyle: TextStyle(color: colorLeBleu),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            width: 2,
            color: colorLeBleu,
          )),
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
