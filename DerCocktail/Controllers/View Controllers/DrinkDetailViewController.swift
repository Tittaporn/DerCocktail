//
//  DrinkDetailViewController.swift
//  DerCocktail
//
//  Created by Lee McCormick on 1/28/21.
//

import UIKit

class DrinkDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkIngredientsTextView: UITextView!
    @IBOutlet weak var drinkInstructionTextView: UITextView!
    
    // MARK: - Properties
    var drink: Drink?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Helper Fuctions
    func updateViews() {
        guard let drink = drink else { return }
        drinkNameLabel.text = drink.strDrink
        drinkIngredientsTextView.text = drink.strIngredient1
        drinkInstructionTextView.text = drink.strInstructions
        fetchDrinkImage(drink: drink)
    }
    
    func fetchDrinkImage(drink: Drink) {
        DrinkController.fetchImage(for: drink) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.drinkImage.image = image
                case .failure(let error):
                    print(error.errorDescription)
                }
            }
        }
    }
}
