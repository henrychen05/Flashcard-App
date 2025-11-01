//
//  DeckSettingsView.swift
//  FlashcardApp
//
//  Created by Henry Chen on 8/20/25.
//

import SwiftUI

//view that shows the settings of selected deck
struct DeckSettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    //current deck to display
    @ObservedObject var deck: DeckData
    //stores name of deck about to be created
    @State var deckname : String
    //original name of deck
    @State var originalDeckName : String
    //stores all cards in deck
    @State var allCards : [CardData]
    //mutable array to store all added flashcard words
    @State var questionList : [String]
    //mutable array to store all added flashcard answers
    @State var answerList : [String]
    //track shake offset of deck
    @State private var shakeOffset: CGFloat = 0
    //track shake offset of list
    @State private var shakeOffsetL :CGFloat = 0
    //boolean for hiding error text
    @State private var isHidden = true
    
    @State var newDeck = DeckData(title: "placeholder")
    @State var newCard = CardData(question: "l", answer: "l", deck: "l")
    
    init(deck: DeckData){
        self.deck = deck
        _deckname = State(initialValue: deck.title)
        _originalDeckName = State(initialValue: deck.title)
        _questionList = State(initialValue: deck.cards.map{$0.question})
        _answerList = State(initialValue: deck.cards.map{$0.answer})
        _allCards = State(initialValue: deck.cards)
    }
    
    
    var body: some View {
        Spacer()
            .frame(height:30)
        VStack(){
            HStack{
                Text("Deck Name: ")
                    .foregroundStyle(.black)
                TextField(text: $deckname, prompt: Text( "Required")){
                }
                .textFieldStyle(.roundedBorder)
                .frame(width:250)
                .offset(x: shakeOffset)
                .animation(.default, value: shakeOffset)
            }
            .frame(height:50)
            List{
                Text("Enter a Word Answer Pair")
                    .foregroundStyle(.red)
                    .opacity(isHidden ? 0 : 1)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                ForEach(allCards.indices, id: \.self){ index in
                    HStack{
                        TextField(text: $allCards[index].question, prompt: Text("Question")){
                        }
                        TextField(text: $allCards[index].answer, prompt: Text("Answer")){
                            
                        }
                        Button(action:{
                            if allCards.count > 1 {
                                if let id = allCards[index].id{
                                    allCards[index].deleteCard(id: id)
                                }
                                allCards.remove(at:index)
                            }
                        }){
                            Image(systemName: "minus.square.fill")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width:20, height:20)
                        }
                        .disabled(allCards.count == 1)
                    }
                }
            
            }
            .frame(width:375, height: 580)
            .cornerRadius(15)
            .padding()
            Button(action:{
                allCards.append(CardData(question: "", answer:"", deck: deckname + "new"))
            }){
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width:25, height:25)
            }
            Button(action:{
                //shake deck if deck name field is empty
                if deckname.isEmpty {
                    shakeDeck()
                }
                //sees if at least one card's question/answer is empty
                var hasEmptyEntry = false
                for card in allCards{
                    if card.question.isEmpty || card.question.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || card.answer.isEmpty || card.answer.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty{
                        hasEmptyEntry = true
                        break
                    }
                }
                //if any question answer pair is empty, show error text
                if hasEmptyEntry{
                    isHidden = false
                }
                else{
                    isHidden = true
                }
                
                //check that all card's question/answer have entries
                var filledEntries = true
                for card in allCards{
                    if card.question.isEmpty || card.question.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || card.answer.isEmpty || card.answer.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty{
                        filledEntries = false
                        break
                    }
                }
                //if all fields are not empty and no duplicate deck name exists, update existing entries and create new cards
                if !deckname.isEmpty && filledEntries && (!ContentView.allDeckTitles.contains(deckname) || deckname == originalDeckName){
                    //update deck and cards
                    if let id = deck.id{
                        deck.updateDeck(id: id, newTitle: deckname)
                    }
                    
                    for i in 0 ..< allCards.count{
                        var question = allCards[i].question
                        var answer = allCards[i].answer
                        if allCards[i].deck == deckname + "new"{
                            newCard.createCard(question: question, answer: answer, deck: deckname)
                        }
                        else{
                            if let id = allCards[i].id{
                                allCards[i].updateCard(id:id, newQuestion: question, newAnswer: answer, newDeck: deckname)
                            }
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                else if ContentView.allDeckTitles.contains(deckname) && deckname != originalDeckName{
                    shakeDeck()
                }
                
            }){
                ZStack{
                    RoundedRectangle(cornerRadius:20)
                        .frame(width:450, height:50)
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(height:25)
                }
                
            }
        }
        .navigationTitle("Edit Deck")
    }

    
    //changes offset
    func shakeDeck() {
        let baseAnimation = Animation.default.speed(5)
        
        withAnimation(baseAnimation) {
            shakeOffset = -15
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(baseAnimation) {
                shakeOffset = 15
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(baseAnimation) {
                shakeOffset = -15
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(baseAnimation) {
                shakeOffset = 15
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(baseAnimation) {
                shakeOffset = 0
            }
        }
    }
}

#Preview {
    DeckSettingsView(deck: DeckData(title: "Animals", cards: allAnimalCards))
}
