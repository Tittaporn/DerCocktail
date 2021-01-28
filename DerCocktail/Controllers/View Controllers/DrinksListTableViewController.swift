//
//  DrinksListTableViewController.swift
//  DerCocktail
//
//  Created by Lee McCormick on 1/28/21.
//

import UIKit

class DrinksListTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var drinkSearchBar: UISearchBar!
    
    // MARK: - Properties
    var drinks: [Drink] = []
    var isSearching: Bool = false
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        drinkSearchBar.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath)

        let drink = drinks[indexPath.row]
        cell.textLabel?.text = drink.strDrink

        return cell
    }

   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDrinkDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? DrinkDetailViewController else { return }
            let drink = drinks[indexPath.row]
            destinationVC.drink = drink
        }
    }
}

extension DrinksListTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            //ContactListTableViewController.sharedInstance.resultsArray = ContactController.sharedInstance.contacts.filter { $0.matches(searchTerm: searchText) }
            
            // search drink by name
            DrinkController.fetchDrinksByName(searchTerm: searchText) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let drinks):
                        self.drinks = drinks.drinks ?? []
                        self.tableView.reloadData()
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                    }
                }
            }
            self.tableView.reloadData()
        } else {
            //ContactListTableViewController.sharedInstance.resultsArray = ContactController.sharedInstance.contacts
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        isSearching = false
       // ContactListTableViewController.sharedInstance.resultsArray = ContactController.sharedInstance.contacts
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
    }
}//End of extension
