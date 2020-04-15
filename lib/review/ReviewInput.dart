import 'package:flutter/material.dart';
import 'package:perspektiv/model/Comment.dart';

import '../main.dart';
import '../model/Category.dart';
import '../model/Review.dart';

class ReviewInput extends StatelessWidget {
  final Review review;
  final Comment comment;

  const ReviewInput({Key key, this.review, this.comment})
      : assert(review != null && comment != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController()
      ..text = comment.comment;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: TextField(
        minLines: 1,
        maxLines: 5,
        controller: _textController,
        onChanged: (val) {
          if (comment.init != false) comment.init = false;

          comment.comment = val;
        },
        autofocus: comment.init,
        style: TextStyle(
            color: colorTextGrey, fontStyle: FontStyle.italic, fontSize: 16),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          suffix: InkWell(
            onTap: () {
              review.comments.remove(comment);
              review.onAddCategory.notifyListeners();
            },
            child: Icon(
              Icons.delete,
              color: colorLove,
            ),
          ),
          hintText: "Kategori navn",
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
