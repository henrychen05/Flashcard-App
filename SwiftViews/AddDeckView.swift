//
//  AddDeckView.swift
//  FlashcardApp
//
//  Created by Henry Chen on 8/24/25.
//

import SwiftUI

struct AddDeckView: View {
    
    @Environment(\.presentationMode) var presentationMode
    //list of all stored decks
    var allDecks : [DeckData]
    //list of all stored decks' titles
    @State var allDeckTitles: [String] = [""]
    //stores name of deck about to be created
    @State var deckname : String = ""
    //mutable array to store all added flashcard words
    @State var questionList : [String] = [""]
    //mutable array to store all added flashcard answers
    @State var answerList : [String] = [""]
    //track shake offset of deck
    @State private var shakeOffset: CGFloat = 0
    //track shake offset of list
    @State private var shakeOffsetL :CGFloat = 0
    //boolean for hiding error text
    @State private var isHidden = true

    @State var newDeck = DeckData(title: "placeholder")
    @State var newCard = CardData(question: "l", answer: "l", deck: "l")
    
    
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
                ForEach(questionList.indices, id: \.self){ index in
                    HStack{
                        TextField(text: $questionList[index], prompt: Text("Question")){
                        }
                        TextField(text: $answerList[index], prompt: Text("Answer")){
                            
                        }
                        Button(action:{
                            if questionList.count > 1 {
                                questionList.remove(at:index)
                            }
                            if answerList.count > 1 {
                                answerList.remove(at:index)
                            }
                        }){
                            Image(systemName: "minus.square.fill")
                                .resizable()
                                .foregroundColor(.blue)
                                .frame(width:20, height:20)
                        }
                        .disabled(questionList.count == 1)
                    }
                }
            
            }
            .frame(width:375, height: 580)
            .cornerRadius(15)
            .padding()
            Button(action:{
                questionList.append("")
                answerList.append("")
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
                //if question answer pair are empty, show error text
                if questionList.isEmpty || questionList[0].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                    answerList.isEmpty || answerList[0].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                    isHidden = false
                }
                else{
                    isHidden = true
                }
                //if all fields are not empty and no duplicate deck name exists, create all entries
                if !deckname.isEmpty && !questionList.isEmpty && !questionList[0].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                    !answerList.isEmpty && !answerList[0].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !allDeckTitles.contains(deckname){
                    //create deck and cards
                    newDeck.createDeck(title: deckname)
                    for i in 0 ..< questionList.count{
                        var question = questionList[i]
                        var answer = answerList[i]
                        newCard.createCard(question: question, answer: answer, deck: deckname)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                else if allDeckTitles.contains(deckname){
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
        .onAppear(){
            for currDeck in allDecks{
                allDeckTitles.append(currDeck.title)
            }
        }
        .navigationTitle("Create a New Deck")
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
    AddDeckView(allDecks: [
        DeckData(title: "Spanish"),
        DeckData(title: "no")]
    )
}
