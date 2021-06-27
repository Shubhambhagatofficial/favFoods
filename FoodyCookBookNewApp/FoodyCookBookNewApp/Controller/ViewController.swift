//
//  ViewController.swift
//  FoodyCookBookNewApp
//
//  Created by Shubham Bhagat on 27/06/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var foodArr = [FoodCookModel]() {
        didSet {
            self.tempFoodArr = foodArr
        }
    }
    var tempFoodArr = [FoodCookModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FoodItemsCell", bundle: nil), forCellReuseIdentifier: "FoodItemsCell")
        self.searchTextField.delegate = self
        self.getFoodData()
        self.setupTextFieldUI()
    }

    func getFoodData(){
        FoodCookViewModel().getFoodItems { foodArr in
            self.foodArr = foodArr
        }
    }
    
    func setupTextFieldUI(){
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        searchTextField.layer.cornerRadius = 8.0
        searchTextField.leftViewMode = .always
        searchTextField.clearButtonMode = .whileEditing
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "  Search Food", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }

    @IBAction func allFavDidTap(_ sender: Any) {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavFoodController") as! FavFoodController
        controller.delegate = self
        self.present(controller, animated: true)
    }
   
}
extension ViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempFoodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemsCell") as! FoodItemsCell
        let obj = self.tempFoodArr[indexPath.row]
        cell.delegate = self
        var isFAV = false
        if let _ = UserDefaults.standard.value(forKey: "favfoods_\(obj.idCategory ?? "")") as? [String:Any] {
            isFAV = true
        }
        cell.configureCell(obj: obj, isFav: isFAV)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.tempFoodArr = self.foodArr
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print(updatedText)
            let arr = self.foodArr.filter({$0.strCategory!.lowercased().contains(updatedText.lowercased())

            })
            self.tempFoodArr = arr

            if updatedText.isEmpty {
                self.tempFoodArr = self.foodArr
            }
        }
        return true
    }
}
extension ViewController :FavouriteButtonDelegate {
    func addFav(obj:FoodCookModel) {
        if let _ = UserDefaults.standard.value(forKey: "favfoods_\(obj.idCategory ?? "")") as? [String:Any] {
            
        } else {
            let dict = [
                "idCategory" :obj.idCategory,
                "strCategory":obj.strCategory,
                "strCategoryThumb":obj.strCategoryThumb,
                "strCategoryDescription":obj.strCategoryDescription
            ]
            UserDefaults.standard.setValue(dict, forKey: "favfoods_\(obj.idCategory ?? " ")")
            UserDefaults.standard.synchronize()
            self.tableView.reloadData()
        }
    }
    
    func deleteFav(cat:String) {
        UserDefaults.standard.removeObject(forKey: "favfoods_\(cat)")
        UserDefaults.standard.synchronize()
        self.tableView.reloadData()
    }
    
    func manageUserDefaults(obj:FoodCookModel){
        UserDefaults.standard.setValue(obj, forKey: "favfoods_\(obj.idCategory ?? "0")")
    }

}
extension ViewController: FavItemsDidChange {
    func didChange() {
        self.tableView.reloadData()
    }
}
