import 'package:flutter/material.dart';
import 'package:meal_roulette/size_config.dart';
import '../models/meal_model.dart';
import '../screens/meal_details_view_screen.dart';
import 'meal_image.dart';

class MealCard extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final MealModel meal;
  const MealCard(
      {super.key,
      required this.id,
      required this.name,
      required this.image,
      required this.meal});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenWidth;
    double height = SizeConfig.screenHeight;
    return Card(
      elevation: 5,
      shadowColor: Colors.green.withOpacity(.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealDetails(
                meal: widget.meal,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageWidget(
              imgUrl: widget.image,
            ),
            SizedBox(height: height * .01),
            Padding(
              padding: EdgeInsets.all(width * .03),
              child: Text(
                widget.name.toUpperCase(),
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
