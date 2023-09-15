//
//  CategryViewController.swift
//  Todoey
//
//  Created by Nafea Elkassas on 12/12/2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    var textFeild = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "cell")
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(hexString: "#1D9BF6")
    }
    
    
    //MARK: - Table view Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let category = categories?[indexPath.row] {
            if let categoryColour = UIColor(hexString: category.cellColour) {
                cell.backgroundColor = categoryColour
                cell.textLabel?.textColor = ContrastColorOf(categoryColour.withBrightness(0.9) ?? .white, returnFlat: true)
            }
            cell.textLabel?.text = category.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
        return cell

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func prepare(for segue : UIStoryboardSegue,sender:Any?){
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories(category : Category) {
        
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print ("Error in seving context \(error)")
        }
        
        self.tableView.reloadData()
        
        
    }
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func UpdateCell(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
    
    
    //MARK: - Adding new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item to your list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add your new item", style: .default) {  (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.cellColour = UIColor.randomFlat().hexValue()
            
            self.saveCategories(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField{ field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        
        present(alert, animated: true)
    }
}
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
extension UIColor {
    func withBrightness(_ brightness: CGFloat) -> UIColor? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var alpha: CGFloat = 0
        guard self.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha) else {
            return nil
        }
        let adjustedBrightness = max(min(brightness, 1), 0)
        return UIColor(hue: hue, saturation: saturation, brightness: adjustedBrightness, alpha: alpha)
    }
}

