import 'package:flutter/material.dart';
import 'package:meal_roulette/widgets/meal_card.dart';
import 'package:provider/provider.dart';
import '../models/meal_model.dart';
import '../providers/meals_provider.dart';
import '../widgets/loading_widget.dart';

class MealSelectionView extends StatefulWidget {
  const MealSelectionView({super.key});

  @override
  State<MealSelectionView> createState() => _MealSelectionViewState();
}

class _MealSelectionViewState extends State<MealSelectionView> {
  late MealsProvider mealsProvider;
  List<dynamic> meals = [];
  List<MealModel> _meals = [];
  bool loading = true;
  int startingIndex = 0;

  @override
  initState() {
    super.initState();
    mealsProvider = Provider.of<MealsProvider>(context, listen: false);
    fetchMeals();
  }

  fetchMeals() async {
    setState(() {
      loading = true;
    });
    meals = await mealsProvider.fetchMeals(startingIndex);
    _meals = mealsProvider.fetchedMeals;
    if (meals.length < 4) {
      startingIndex = 0;
    } else {
      startingIndex += 4;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal Selection View',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 5.0,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          loading
              ? const Center(child: LoadingWidget())
              : GridView.count(
                  padding: const EdgeInsets.all(7),
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  semanticChildCount: meals.length,
                  childAspectRatio: 200 / 244,
                  physics: const BouncingScrollPhysics(),
                  children: _meals.map((meal) {
                    return MealCard(
                      name: meal.title!,
                      image: meal.imgUrl!,
                      id: meal.id!,
                      meal: meal,
                    );
                  }).toList(),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (!loading) {
                  fetchMeals();
                }
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: loading ? Colors.transparent : Colors.white,
                    width: 2.0,
                  ),
                  color: loading ? Colors.transparent : Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: loading
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 16,
                      color: loading ? Colors.transparent : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
