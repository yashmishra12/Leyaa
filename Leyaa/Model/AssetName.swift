//
//  AssetName.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import Foundation
import SwiftUI

//MARK: - Image Names
let assetName = ["Almond", "Apple", "Avocado", "Banana", "BandAid", "Battery", "Beer", "Bell Pepper", "Biscuit", "Body Lotion", "Body Wash", "Boots", "Bottle", "Bread", "Broccoli", "Bucket", "Bug Spray", "Bulb", "Butter", "Cabbage", "Calculator", "Candle" ,"Carrot", "Cashew", "Cauliflower", "Cereal", "Cheese", "Cherry", "Chicken", "Chilli", "Chips", "Chocolate", "Cigarette", "Clock", "Clove", "Coffee", "Cola" ,"Conditioner", "Condom", "Converse", "Cookies", "Cooking Oil", "Corn", "Corn Flakes", "Crocs", "Cucumber","Deodorant", "Detergent", "Dish Washer", "Egg", "Eggplant", "Energy Drink", "Face Wash", "Fish", "Flour", "Flowers", "Formal Shoes", "Garlic", "Glue", "Ginger" ,"Grapes", "Guava", "Hand Wash", "Hat", "High Heels", "Honey", "Ice Cream", "Jam", "Juice", "Ketchup", "Knife" ,"Kitchen Roll", "Lamp", "Lemon", "Lentil", "Lobster", "Lube", "Mango", "Meat", "Milk", "Mouth Wash" ,"Mushroom", "Okra", "Onion", "Orange", "Pad", "Pea", "Peanut Butter", "Pen", "Pencil", "Pineapple", "Pomegranate", "Potato", "Pulses", "Pumpkin", "Radish", "Rainboot", "Ramen", "Rice", "Running Shoes", "Salt", "Sanitizer", "Scissors", "Shampoo", "Slippers", "Smoke", "Snacks", "Soap", "Spinach", "Sports Shoes", "Squash", "Stir Fry", "Strawberry", "Study Lamp", "Sugar", "Sunscreen", "Sweet Potato", "Tampon", "Tea", "Trash Bag" ,"Toilet Paper", "Tomato", "Toothbrush", "Toothpaste", "Tortilla" ,"Tuna", "Turkey", "Turnip", "Watch", "Water Melon", "Wine", "Yogurt"]

let relaxPic: [String] = ["relax1", "relax2", "relax3", "relax4", "relax5", "relax6", "relax7"]

//MARK: - Constants

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let defaultAvatar = "coffee"
let deviceTokenStorage = "com.yashmisra12.Leyaa.kDeviceToken"

let cardWidth = screenWidth * 0.5

//MARK: - Grid Layout
var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]

var fiveColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

var threeRowGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]


