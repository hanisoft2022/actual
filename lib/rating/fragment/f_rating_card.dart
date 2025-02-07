import 'package:actual/common/const/color.dart';
import 'package:actual/rating/model/m_rating.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:collection/collection.dart';

class FRatingCard extends StatelessWidget {
  // NetworkImage
  // AssetImage
  //
  // CircleAvatar
  final ImageProvider avatarImage;
  // 리스트로 위젯 이지를 보여줄 때
  final List<Image> images;
  // 별점
  final int rating;
  // 이메일
  final String email;
  // 리뷰 내용
  final String content;

  const FRatingCard({
    super.key,
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
  });

  factory FRatingCard.fromModel({
    required MRating model,
  }) =>
      FRatingCard(
        avatarImage: NetworkImage(model.user.imageUrl),
        images: model.imgUrls.map((e) => Image.network(e)).toList(),
        rating: model.rating,
        email: model.user.username,
        content: model.content,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(avatarImage: avatarImage, email: email, rating: rating),
        const Gap(8),
        _Body(content: content),
        if (images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              height: 100,
              child: _Images(images),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header({
    required this.avatarImage,
    required this.email,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const Gap(8),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: COLOR_PRIMARY,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: const TextStyle(
              color: COLOR_BODY_TEXT,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images(this.images);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, image) => Padding(
              padding: EdgeInsets.only(right: index == images.length - 1 ? 0 : 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
            ),
          )
          .toList(),
    );
  }
}
