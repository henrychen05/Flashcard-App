//
//  CardFrontView.swift
//  FlashcardApp
//
//  Created by Henry Chen on 8/17/25.
//

import SwiftUI

//view of flashcards
struct CardFrontView: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    //current deck to display
    @ObservedObject var deck: DeckData
    
    //current index in deck
    @State var currentIndex = 0
    //@State var currentCard = deck.cards[0]
    @State var opacity = 1.0
    
    //current card
    private var currentCard: CardData {
        deck.cards[currentIndex]
    }

    var body: some View {
        
        
        HStack{
            
            ZStack{
                VStack{
                    //back button
                    Spacer()
                        .navigationBarBackButtonHidden(true)
                        .toolbar(content: {
                            ToolbarItem(placement:.navigationBarLeading){
                                Button{
                                    presentationMode.wrappedValue
                                        .dismiss()
                                }label: {
                                    Image(systemName: "arrowshape.backward.fill")
                                        .foregroundColor(.white)
                                    .padding()
                                    .background(Color(red: 0.8, green: 0.8, blue: 0.8))
                                    .clipShape(Circle())
                                }
                            }
                        })
                    
                    //left button
                    Button {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                        if currentIndex == 0{
                            
                        }
                        else{
                            deck.cardFlipped = false
                        }
                        if currentIndex > 0{
                            currentIndex = currentIndex - 1
                        }
                        
                    }label: {
                        Text("  ")
                        .padding(.horizontal, 20)
                        .clipShape(Rectangle())
                        .frame(height:763)
                        .background(Color(red: 0, green: 0, blue: 1))
                        .opacity(0)
                    }
                }
                
            }
            
            Spacer()

            VStack{
                //vocab word in middle
                if deck.cardFlipped == false{
                    Text(currentCard.question)
                        .font(.custom("Times New Roman", fixedSize: 30))
                        .foregroundStyle(Color.black)
                }
                else if deck.cardFlipped == true{
                    //answer in middle
                    Text(currentCard.answer)
                        .font(.custom("Times New Roman", fixedSize: 30))
                        .foregroundStyle(Color.black)
                }
                Spacer()
                    .frame(height:40)
                //flip card button
                Button{
                    if deck.cardFlipped == true {
                        deck.cardFlipped = false
                    }
                    else{
                        deck.cardFlipped = true
                    }

                    
                }label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(.white)
                        .padding()
                    .background(Color(red: 0.8, green: 0.8, blue: 0.8))
                    .clipShape(Circle())
                    
                }
            }
            
            Spacer()
            
            //right button
            Button {
                if currentIndex == deck.cards.count - 1{
                    
                }
                else{
                    deck.cardFlipped = false
                }
                if currentIndex < deck.cards.count - 1{
                    currentIndex = currentIndex + 1
                }
            }label: {
                Text("  ")
                .padding(.horizontal, 20)
                .clipShape(Rectangle())
                .frame(height:763)
                .background(Color(red: 0, green: 0, blue: 1))
                .opacity(0)
            }
        }
        //background color
        .background(Color.white)
    }
}

#Preview {
    CardFrontView(deck: DeckData(title: "Animals", cards: allAnimalCards))
}
