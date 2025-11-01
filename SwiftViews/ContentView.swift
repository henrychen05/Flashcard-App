//
//  ContentView.swift
//  FlashcardApp
//
//  Created by Henry Chen on 8/16/25.
//

import SwiftUI

// class that manages all decks
class DeckStore: ObservableObject {
    @Published var decks: [DeckData] = []
    @Published var cards: [CardData] = []

    func refresh() {
        DeckData.getAllDecks { fetchedDecks in
            CardData.getAllCards { fetchedCards in
                DispatchQueue.main.async {
                    var loadedDecks = fetchedDecks
                    let loadedCards = fetchedCards

                    // assign cards to decks
                    for card in loadedCards {
                        if let index = loadedDecks.firstIndex(where: { $0.title == card.deck }) {
                            loadedDecks[index].cards.append(card)
                        }
                    }

                    self.decks = loadedDecks
                    self.cards = loadedCards
                    ContentView.allDeckTitles = loadedDecks.map { $0.title }
                }
            }
        }
    }
}

// home screen view
struct ContentView: View {
    @StateObject private var store = DeckStore()

    static var allDeckTitles: [String] = [""]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer().frame(width: 35)

                    //refresh button
                    Button(action: { store.refresh() }) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                    }

                    Spacer().frame(width: 200)

                    //add deck button
                    NavigationLink(destination: AddDeckView(allDecks: store.decks)) {
                        Image(systemName: "plus.app.fill")
                            .foregroundColor(.blue)
                            .frame(width: 100, height: 10)
                    }
                }

                // swipe list view
                TabView {
                    ForEach(store.decks) { deck in
                        ZStack {
                            VStack {
                                Spacer()

                                // if deck has cards
                                if deck.cards.count > 0 {
                                    NavigationLink(destination: CardFrontView(deck: deck)) {
                                        deckCard(title: deck.title)
                                    }
                                } else {
                                    NavigationLink(destination: EmptyDeckView()) {
                                        deckCard(title: deck.title)
                                    }
                                }

                                HStack {
                                    NavigationLink(destination: DeckSettingsView(deck: deck)) {
                                        Label("Edit", systemImage: "pencil")
                                    }

                                    Spacer().frame(width: 100)

                                    Button(action: {
                                        for card in deck.cards {
                                            if let id = card.id {
                                                card.deleteCard(id: id)
                                            }
                                        }
                                        if let id = deck.id {
                                            deck.deleteDeck(id: id)
                                        }
                                        store.refresh()
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                        }
                    }
                }
                .tabViewStyle(.page)
                .ignoresSafeArea(.all, edges: .bottom)
                .onAppear { store.refresh() }
            }
        }
    }

    @ViewBuilder
    private func deckCard(title: String) -> some View {
        Text(title)
            .foregroundStyle(.white)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding()
            .frame(width: 320, height: 700)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .shadow(radius: 5)
            )
    }
}


#Preview {
    ContentView()
}
