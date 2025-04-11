import json 

class Food:
    def __init__(self, filename='food_list.json'):
        self.load(filename=filename)

    def load(self, filename):
        file = open(filename, 'r')
        json_food_list = file.read()
        file.close()
        
        food_list = json.loads(json_food_list)
        
        self.dict_prices = {}
        for price in food_list:
            self.dict_prices[price["food_name"]] = price["cost"]
        
    def get_price(self, food_name):
        return self.dict_prices[food_name]
        

