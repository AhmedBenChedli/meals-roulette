import 'package:flutter/material.dart';
import 'package:meal_roulette/size_config.dart';
import 'package:meal_roulette/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import '../models/meal_model.dart';
import '../providers/meals_provider.dart';
import '../widgets/meal_image.dart';

class MealDetails extends StatefulWidget {
  final MealModel meal;
  const MealDetails({super.key, required this.meal});

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  bool loading = true;
  late MealsProvider mealsProvider;
  int id = 0;
  late MealModel meal;
  late MealModel mealWithDetails;
  List<String> parts = [];

  @override
  void initState() {
    id = widget.meal.id!;
    meal = widget.meal;
    mealsProvider = Provider.of<MealsProvider>(context, listen: false);
    fetchMealDetails();
    super.initState();
  }

  fetchMealDetails() async {
    mealWithDetails = await mealsProvider.fetchMealDetails(meal, id);
    String trimmedText =
        mealWithDetails.ingredients!.trim().replaceAll(RegExp(r'\s+'), ' ');
    parts = trimmedText.split(',');
    setState(() {
      loading = false;
    });
  }

  List<Card> buildTiles() {
    return parts
        .map(
          (ingredient) => Card(
            elevation: 3,
            shadowColor: Colors.green.withOpacity(.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: RichText(
                  text: _getColoredTextSpan(
                ingredient.trim(),
              )),
            ),
          ),
        )
        .toList();
  }

  bool _isNumeric(String word) {
    if (word.isEmpty) return true;
    // Remove non-numeric characters except for dot and minus sign
    final cleanedWord = word.replaceAll(RegExp(r'[^0-9\.-]'), '');
    return double.tryParse(cleanedWord) != null;
  }

  TextSpan _getColoredTextSpan(String text) {
    final List<TextSpan> textSpans = [];
    // Split the text by whitespace and iterate through each word
    final List<String> words = text.split(' ');
    for (var word in words) {
      if (_isNumeric(word)) {
        // If the word is a number, display it in a different color
        textSpans.add(TextSpan(
          text: '$word ',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green),
        ));
      } else {
        textSpans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[600],
          ),
        ));
      }
    }
    return TextSpan(children: textSpans);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenHeight;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Meal Details View',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 5.0,
      ),
      body: loading
          ? const Center(
              child: LoadingWidget(),
            )
          : SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageWidget(
                    imgUrl: mealWithDetails.imgUrl!,
                    size: height * .5,
                    borderRadius: 0.0,
                  ),
                  SizedBox(height: height * .01),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      mealWithDetails.title!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      mealWithDetails.description!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  SizedBox(height: height * .01),
                  Column(
                    children: buildTiles(),
                  )
                ],
              ),
            ),
    );
  }
}
