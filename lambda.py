import json
pets = {
  "name": "Purrsloud",
  "favFoods": ["wet food", "dry food", "<strong>any</strong> food"],
  "photo": "https://learnwebcode.github.io/json-example/images/cat-2.jpg"
}
pets = {
  "name": "Meowsalot",
  "favFoods": ["tuna", "catnip", "celery"],
  "photo" : "https://learnwebcode.github.io/json-example/images/cat-1.jpg"
}

pets_dict = json.loads(pets)

# Output: 
print(pets_dict['favFoods'])





