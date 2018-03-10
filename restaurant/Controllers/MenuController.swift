//
//  MenuController.swift
//  restaurant
//
//  Created by Jan Marten Sevenster on 08/03/2018.
//  Copyright © 2018 John Appleseed. All rights reserved.
//

import Foundation
import UIKit

class MenuController {
    static let shared = MenuController()
    // all MenuControllers share this
    
    let baseURL = URL(string: "https://resto.mprog.nl/")!
    // assigning server URL
    
    func fetchCategories(completion: @escaping ([String]?) -> Void){
        let categoryURL = baseURL.appendingPathComponent("categories")
        
        let task = URLSession.shared.dataTask(with: categoryURL)
        { (data, response, error) in
            if let data = data, let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String:Any], let categories = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            } else {
            completion(nil)
            }
        }
        task.resume()
    }
    // fetch and decode different categories from server
    
    func fetchMenuItems(categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        
        let task = URLSession.shared.dataTask(with: menuURL)
        { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    // fetch and decode different dishes from derver
    
    func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    // encode and send ordered dishes to derver
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) ->
        Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    // fetch the image from the server corresponding to the item you were fetching already
}

