//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController : SwipeTableViewController  {
    var ItemArray : Results<Item>?
    let realm = try! Realm()
    var textFeild = UITextField()
    
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    @IBOutlet weak var newItembutton: UIBarButtonItem!
    @IBOutlet weak var backButtom: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        if let colorHex = selectedCategory?.cellColour {
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exists.")}
            if let bgColor = UIColor(hexString: colorHex) {
                navBar.backgroundColor = bgColor
                navBar.standardAppearance.backgroundColor = bgColor
                navBar.scrollEdgeAppearance?.backgroundColor = bgColor
                navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(bgColor, returnFlat: true)]
                navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(bgColor, returnFlat: true)]
                searchBar.barTintColor = bgColor
                searchBar.searchTextField.backgroundColor = FlatWhite()
                
                newItembutton.tintColor = ContrastColorOf(bgColor, returnFlat: true)
            }
        }
    }
    
    //MARK: - Table view Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = ItemArray?[indexPath.row] {
            cell.textLabel?.text=item.title
            if let colour = UIColor(hexString: selectedCategory!.cellColour)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat(ItemArray!.count)){
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text="no items added"
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = ItemArray?[indexPath.row]{
            do {
                try realm.write{
                    
                    item.done = !item.done
                }
            }
            catch {
                print("error checking your item")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Data Manipulation
    func loadItems() {
        ItemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func UpdateCell(at indexPath: IndexPath) {
        if let DeletedItem = self.ItemArray?[indexPath.row] {
            do{
                try self.realm.write {
                    
                    self.realm.delete(DeletedItem)
                } }
            catch {
                print("error deleting to do item\(error)")
            }
            
            
        }
    }
    
    //MARK: - For Adding New Items
    
    @IBAction func addButtonSelected(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item to your list", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add your new item", style: .default) {  (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateModified = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                }
                catch {
                    print("error saving new item\(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder="Add here your new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
}

//MARK: - Search Bar Controller
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        ItemArray = ItemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateModified" , ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

