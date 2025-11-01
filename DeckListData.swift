//
//  DeckListData.swift
//  FlashcardApp
//
//  Created by Henry Chen on 9/3/25.
//

import Foundation
import SwiftUI

class DeckListData: ObservableObject {
    
    //contains all decks created
    @Published var deckList: [DeckData] = []
    
    
    
}
//test
var card1 = CardData(question: "what animal has wings", answer: "bird", deck:"Animals")
var card2 = CardData(question: "what farm animal lays eggs", answer: "chicken", deck:"Animals")
var card3 = CardData(question: "what animal is mans best friend", answer: "dog", deck:"Animals")
var card4 = CardData(question: "what mammal lives in the ocean", answer: "whale", deck:"Animals")

var allAnimalCards = [card1, card2, card3, card4]


