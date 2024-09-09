import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meals_provider.dart';

class ImageWidget extends StatefulWidget {
  final String imgUrl;
  final double size;
  final double borderRadius;
  const ImageWidget(
      {super.key,
      required this.imgUrl,
      this.size = 140,
      this.borderRadius = 10.0});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool imageReady = false;
  late MealsProvider mealsProvider;
  bool checking = true;

  @override
  void initState() {
    super.initState();
    mealsProvider = Provider.of<MealsProvider>(context, listen: false);
    checkImage();
  }

  checkImage() async {
    bool check = await mealsProvider.checkImageValidity(widget.imgUrl);
    if (mounted) {
      setState(() {
        imageReady = check;
        checking = false;
      });
    }
  }

  Widget getImage() {
    try {
      return imageReady
          ? ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: FadeInImage.assetNetwork(
                width: widget.size,
                height: widget.size,
                placeholder: 'assets/placeholder.png',
                image: widget.imgUrl,
                fit: BoxFit.cover,
              ),
            )
          : placeHolderImage();
    } catch (e) {
      return const Icon(
        Icons.warning_rounded,
        color: Colors.orangeAccent,
        size: 100,
      );
    }
  }

  Widget placeHolderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.asset(
        'assets/placeholder.png',
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: checking ? placeHolderImage() : getImage(),
    );
  }
}
