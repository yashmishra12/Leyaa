//
//  AssetName.swift
//  Leyaa
//
//  Created by Yash Mishra on 6/26/22.
//

import Foundation
import SwiftUI

//MARK: - Image Names

let assetName = ["Almond", "Apple", "Avocado", "Bagel", "Banana", "Bandaid", "Battery", "Bean", "Beer", "Bell Pepper", "Biscuit", "Body Lotion", "Body Wash", "Boots", "Bottle", "Bread", "Broccoli", "Broom", "Bucket", "Bug Spray", "Bulb", "Butter", "Cabbage", "Calculator", "Can Opener", "Candle", "Cap", "Carrot", "Cashew", "Cauliflower", "Cereal", "Cheese", "Cherry", "Chicken", "Chilli", "Chips", "Chocolate", "Chopping Board", "Cigarette", "Cilantro" ,"Cleaner", "Clock", "Clove", "Coffee", "Cola", "Conditioner", "Condom", "Contact Lens", "Converse", "Cookies", "Cooking Oil", "Corn", "Corn Flakes", "Crocs", "Cucumber", "Deodorant", "Detergent", "Dish Washer", "Donut", "Egg", "Eggplant", "Energy Drink", "Face Wash", "Fish", "Flour", "Flowers", "Fork", "Formal Shoes", "Freshener", "Garlic", "Ginger", "Gloves", "Glue", "Grapes", "Guava", "Hand Wash", "Hat", "High Heels", "Honey", "Ice Cream", "Jalapeno", "Jam", "Jelly", "Juice", "Ketchup", "Kitchen Roll", "Knife", "Lamp", "Lemon", "Lentil", "Lobster", "Lube", "Mango", "Meat", "Milk", "Mittens", "Mop", "Mouth Wash", "Mug", "Muscle Cream", "Mushroom", "Nail Clipper", "Nail Polish", "Napkin", "Notebook", "Okra", "Onion", "Orange", "Pad", "Pea", "Peanut Butter", "Pen", "Pencil", "Pineapple", "Plate", "Pomegranate", "Pop Corn", "Potato", "Pulses", "Pumpkin", "Radish", "Rainboot", "Ramen", "Rice", "Rum", "Running Shoes", "Salt", "Sanitizer", "Sausage", "Scissors", "Shampoo", "Shoes", "Slippers", "Smoke", "Smoothie", "Snacks", "Soap", "Soda", "Spinach", "Spoon", "Sports Shoes", "Squash", "Stir Fry", "Strawberry", "Study Lamp", "Sugar", "Sun Glasses", "Sunscreen", "Sweet Potato", "Tampon", "Tea", "Thermometer", "Tissue Paper", "Toilet Brush", "Toilet Paper", "Tomato", "Toothbrush", "Toothpaste", "Tortilla", "Trash Bag", "Tuna", "Turkey", "Turnip", "Vacuum Cleaner", "Vodka", "Watch", "Water Melon", "Wet Wipes", "Whiskey", "Wine", "Yogurt"]

let relaxPic: [String] = ["relax1", "relax2", "relax3", "relax4", "relax5", "relax6", "relax7"]

//MARK: - Constants

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height


let deviceTokenStorage = "com.yashmisra12.Leyaa.kDeviceToken"
let profileKey = "com.yashmishra12.Leyaa.profilePicStored"

let defaultAvatar = UserDefaults.standard.string(forKey: profileKey) ?? "coffee"

let privacyPolicyURL = "https://pages.flycricket.io/leyaa/privacy.html"
let appSupportURL = "https://docs.google.com/forms/d/e/1FAIpQLScu8qcUppE9WREnJJC-b05zrHe5wn72ue7JfFvDKT09BJ4pEg/viewform"
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.4.2"

let cardWidth = screenWidth * 0.5

//MARK: - Grid Layout
var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]

var fiveColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

var threeRowGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]


