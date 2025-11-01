//
//  CardData.swift
//  FlashcardApp
//
//  Created by Henry Chen on 8/17/25.
//

import Foundation
import SwiftUI

struct CardData: Codable {
    //id of card
    var id : Int?
    //vocab word
    var question: String
    //answer to vocab
    var answer: String
    //name of deck that card belongs to
    var deck: String
    
    init(question: String, answer: String, deck: String){
        self.question = question
        self.answer = answer
        self.deck = deck
    }
    
    static func getAllCards(completion: @escaping ([CardData]) -> Void){
        
        //server url
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/flashcards/")
        else{
            return
        }
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            guard let data = data else {
                return
            }
            //decodes data
            do {
                let cards = try JSONDecoder().decode([CardData].self, from: data)
                completion(cards)
                print(cards)
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
        
    }
    
    func createCard(question: String, answer: String, deck: String){
        
        //server url
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/flashcards/")
        else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let card = CardData(question: question, answer: answer, deck: deck)
        request.httpBody = try? JSONEncoder().encode(card)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    print(String(data: data, encoding: .utf8)!)
                }
            }.resume()
        
    }
    
    //method that updates question field
    func updateCard(id: Int, newQuestion: String){
        
        //server url of card
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/flashcards/\(id)/")
        else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = ["question" : newQuestion]
        request.httpBody = try? JSONEncoder().encode(updateData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }
        }.resume()
        
    }
    
    //method that updates answer field
    func updateCard(id: Int, newAnswer: String){
        
        //server url of card
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/flashcards/\(id)/")
        else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = ["answer" : newAnswer]
        request.httpBody = try? JSONEncoder().encode(updateData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }
        }.resume()
        
    }
    
    //method that updates question and answer fields
    func updateCard(id: Int, newQuestion: String, newAnswer: String){
        
        //server url of card
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/flashcards/\(id)/")
        else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = ["question": newQuestion, "answer" : newAnswer]
        request.httpBody = try? JSONEncoder().encode(updateData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }
        }.resume()
        
    }
    
    //method that updates question and answer fields and deck field
    func updateCard(id: Int, newQuestion: String, newAnswer: String, newDeck: String){
        
        //server url of card
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/flashcards/\(id)/")
        else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updateData = ["question": newQuestion, "answer" : newAnswer, "deck" : newDeck]
        request.httpBody = try? JSONEncoder().encode(updateData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
            }
        }.resume()
        
    }
    
    //deletes card given id
    func deleteCard(id: Int){
        
        //server url of card
        guard let url = URL(string:"http://127.0.0.1:8000/api/database/flashcards/\(id)/")
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
    
}

