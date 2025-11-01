//
//  DeckData.swift
//  FlashcardApp
//
//  Created by Henry Chen on 8/17/25.
//

import Foundation
import SwiftUI

    
class DeckData: ObservableObject, Identifiable, Codable, Hashable {
    //id of deck
    var id: Int?
    //title of deck
    @Published var title: String
    //checks to see if view should display answer, always false by default
    @Published var cardFlipped: Bool
    //all cards within deck
    @Published var cards: [CardData]
    
    init(title: String, cards: [CardData], cardFlipped: Bool = false) {
        self.title = title
        self.cards = cards
        self.cardFlipped = cardFlipped
    }
        
    
    init(id: Int, title: String, cardFlipped: Bool = false) {
        self.id = id
        self.title = title
        self.cardFlipped = cardFlipped
        self.cards = []
    }
     
    
    init(title: String){
        self.title = title
        self.cardFlipped = false
        self.cards = []
    }

    
    //used to refer to variables while during decoding and encoding
    enum CodingKeys: String, CodingKey {
            case id,
                 title, cardFlipped
    }
    
    //reads properties from JSON file
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(Int.self, forKey: .id)
            self.title = try container.decode(String.self, forKey: .title)
            self.cards = []
            self.cardFlipped = false
    }

    //converts deck class into JSON
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(false, forKey: .cardFlipped)
    }
    
    //gets all decks from database
    static func getAllDecks(completion: @escaping ([DeckData]) -> Void){
        //server url
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/decks/")
        else{
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    return
                }
                //decodes data
                do {
                    let decks = try JSONDecoder().decode([DeckData].self, from: data)
                    completion(decks)
                    print(decks)
                } catch {
                    print("Decoding error: \(error)")
                }
        }.resume()
    }
    
    //creates a new deck
    func createDeck(title: String){
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/decks/")
        else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let deck = DeckData(title: title)
        request.httpBody = try? JSONEncoder().encode(deck)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: .utf8)!)
                }
            }.resume()
        
    }
    
    //updates title of deck
    func updateDeck(id: Int, newTitle: String){
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/decks/\(id)/")
        else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = ["title" : newTitle]
        request.httpBody = try? JSONEncoder().encode(updateData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }
        }.resume()
        
    }
    
    //deletes deck given id
    func deleteDeck(id: Int){
        
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/decks/\(id)/")
        else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    print("Deleted with status code: \(httpResponse.statusCode)")
                }
        }.resume()
        
    }
    
    static func == (lhs: DeckData, rhs: DeckData) -> Bool {
           lhs.id == rhs.id
       }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    
}

