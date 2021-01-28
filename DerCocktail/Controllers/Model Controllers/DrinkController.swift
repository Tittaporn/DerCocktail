//
//  DrinkController.swift
//  DerCocktail
//
//  Created by Lee McCormick on 1/28/21.
//

import UIKit

/*
 Search cocktail by name
 https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita

 List all cocktails by first letter
 https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a

 Lookup a random cocktail
 https://www.thecocktaildb.com/api/json/v1/1/random.php
 */

class DrinkController {
    
    // MARK: - Properties
    static let baseURL = URL(string: "https://www.thecocktaildb.com/api/json/v1/1")
    static let randomEndpoint = "random"
    static let phpExtension = "php"
    static let searchEndpoint = "search"
    static let searchByNameQuery = "s"
    static let searchByLetterQuery = "f"
    
    // MARK: - Fetch Random Cocktail
    static func fetchDrink(completion: @escaping (Result<Drink?,DrinkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let randomURL = baseURL.appendingPathComponent(randomEndpoint)
        let finalURL = randomURL.appendingPathExtension(phpExtension)
        // https://www.thecocktaildb.com/api/json/v1/1/random.php
        print("\nFinalURL for a random drink ::: \(finalURL)")
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData))}
            do {
                let drinks = try JSONDecoder().decode(Drinks.self, from: data)
                let drink = drinks.drinks?[0]
                completion(.success(drink))
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    // MARK: - Fetch An Image Of A Drink
    static func fetchImage(for drink: Drink, completion: @escaping (Result<UIImage,DrinkError>) -> Void) {
        guard let imageURL = URL(string: drink.strDrinkThumb ?? "") else {return completion(.failure(.invalidURL))}
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return(completion(.failure(.noData)))}
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(image))
        }.resume()
    }
    
    // MARK: - Fetch Drinks by name
    static func fetchDrinksByName(searchTerm: String, completion: @escaping (Result<Drinks,DrinkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let searchURL = baseURL.appendingPathComponent(searchEndpoint)
        let phpExtensionURL = searchURL.appendingPathExtension(phpExtension)
        var urlComponents = URLComponents(url: phpExtensionURL, resolvingAgainstBaseURL: true)
        let nameQuery = URLQueryItem(name: searchByNameQuery, value: searchTerm)
        urlComponents?.queryItems = [nameQuery]
        guard let finalURL = urlComponents?.url else {return(completion(.failure(.invalidURL)))}
        print("\nFinalURL For Fetch Drinks by Name ::: \(finalURL)")
        //https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            do {
                let drinks = try JSONDecoder().decode(Drinks.self, from: data)
                completion(.success(drinks))
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    // MARK: - Fetch Drinks By Letter
    static func fetchDrinksByLetter(letter: String, completion: @escaping (Result<Drinks,DrinkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let searchURL = baseURL.appendingPathComponent(searchEndpoint)
        let phpURL = searchURL.appendingPathExtension(phpExtension)
        var urlComponents = URLComponents(url: phpURL, resolvingAgainstBaseURL: true)
        let letterQuery = URLQueryItem(name: searchByLetterQuery, value: letter)
        urlComponents?.queryItems = [letterQuery]
        guard let finalURL = urlComponents?.url else { return completion(.failure(.invalidURL))}
        print("\nFinalURL for Fetch Drinks By Letter ::: \(finalURL)")
        // https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData))}
            do {
                let drinks = try JSONDecoder().decode(Drinks.self, from: data)
                completion(.success(drinks))
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
   
}
