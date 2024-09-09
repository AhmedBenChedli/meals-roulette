# Meal Roulette App Mobile Pagination

The app has a meal selection view and a meal details view.

Tapping on the refresh button presents a selection of the next 4 meals.

Tapping on a meal on the list opens the details view for that meal. 

There is also a way to navigate back to the list view from the details view.

### REST 

<details>
 	<summary>Click to expand the request examples.</summary>

#### Get all meals

https://playground.devskills.co/api/rest/meal-roulette-app/meals

#### Get 4 meals starting from index 4

https://playground.devskills.co/api/rest/meal-roulette-app/meals/limit/4/offset/4

#### Get the meal with id 4

https://playground.devskills.co/api/rest/meal-roulette-app/meals/4

</details>

### GraphQL

 <details>
 	<summary>Click to expand the request examples.</summary>

 	Endpoint: https://playground.devskills.co/v1/graphql

#### Get all meals

```
query GetAllMeals {
  meal_roulette_app_meals {
    id
    title
    picture
    description
    ingredients
  }
}
```

#### Get 4 meals starting from index 4

```
query MealsWithOffset {
  meal_roulette_app_meals_aggregate(limit: 4, offset: 4) {
    nodes {
      id
      title
      picture
      description
      ingredients
    }
  }
}
```

#### Get the meal with id 5

```
query SingleMeal {
  meal_roulette_app_meals_by_pk(id: 5) {
    id
    title
    picture
    description
    ingredients
  }
}
```

### GraphiQL Sandbox

[Here](https://meal-roulette-app.web.app/) you can play with the Meal Roulette GraphQL API. Start by copy-pasting an example from above.

</details>
