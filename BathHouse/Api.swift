//
//  Api.swift
//  BathHouse
//
//  Created by Jes Yang on 2019/11/19.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

let urlAPI = "https://1ed4813f.ngrok.io/api"

// MARK: - BathHouse
struct BathHouse: Codable {
    let currentNumberOfPeople, maxNumberOfPeople: Int
    let nextPersonWillLeaveAt: String?
    let peopleInTheHouse, peopleWithDrinks: [People]

    enum CodingKeys: String, CodingKey {
        case currentNumberOfPeople = "current_number_of_people"
        case maxNumberOfPeople = "max_number_of_people"
        case nextPersonWillLeaveAt = "next_person_will_leave_at"
        case peopleInTheHouse = "people_in_the_house"
        case peopleWithDrinks = "people_with_drinks"
    }
}

// MARK: - People
struct People: Codable {
    let id: Int
    let userName: String
    let gender: Gender
    let withDrink: Int
    let enteredAt, expiredAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case gender
        case withDrink = "with_drink"
        case enteredAt = "entered_at"
        case expiredAt = "expired_at"
    }
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

// MARK: - User
struct User: Codable {
    let user_name: String
    let gender: String
}

struct NewUserResponse: Codable {
    let message: String
}


class BathHouseData {
    
    func getBathHousePeople(completion: @escaping (BathHouse) -> Void) {
            
        let url = URL(string: "\(urlAPI)/bathhouses")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...400).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            guard let data = data else { return }
            
            do {
                let bathHouse = try JSONDecoder().decode(BathHouse.self, from: data)
                completion(bathHouse)
                
            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
        }
        
        task.resume()
    }
    
    func sendPeopleToBathHouse(name: String, gender: String, completion: @escaping (NewUserResponse) -> Void) {
            
        let user = User(user_name: name, gender: gender)
                
                guard let uploadData = try? JSONEncoder().encode(user) else {
                    return
                }
                
                let url = URL(string: "\(urlAPI)/bathhouses")!
                var request = URLRequest(url: url)
                
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
                    
                    if let error = error {
                        print ("error: \(error)")
                        return
                    } else {
                        print ("Upload successed.")
                    }
                    
                    guard let response = response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode) else {
        
                            print ("server error")
                            return
                    }
                    
        //            let mimeType = response.mimeType,
        //            mimeType == "application/json"
                    
                    if let data = data {
                        
                        do {
                            let responseData = try JSONDecoder().decode(NewUserResponse.self, from: data)
                            completion(responseData)
                            
                        } catch let jsonErr {
                            print("Error serialization json: \(jsonErr)")
                        }
                    }
                }
                
                task.resume()
    }
}
