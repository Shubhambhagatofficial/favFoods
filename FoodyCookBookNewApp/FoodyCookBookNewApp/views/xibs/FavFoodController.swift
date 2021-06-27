//
//  FavFoodController.swift
//  FoodyCookBookNewApp
//
//  Created by Shubham Bhagat on 27/06/21.
//

import UIKit
protocol FavItemsDidChange:AnyObject {
    func didChange()
}
class FavFoodController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate : FavItemsDidChange? = nil
    
    var favFoodArr = [FoodCookModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FoodItemsCell", bundle: nil), forCellReuseIdentifier: "FoodItemsCell")
        self.fetchAllFav()
    }
    
    func fetchAllFav(){
        let keys = UserDefaults.standard.dictionaryRepresentation().keys.filter { return $0.hasPrefix("favfoods_") }
        var tempArr = [FoodCookModel]()
        for key in keys {
            if let dict = UserDefaults.standard.value(forKey: key) as? [String:Any] {
                tempArr.append(FoodCookModel.init(dict: dict))
            }
        }
        self.favFoodArr = tempArr
    }

}
extension FavFoodController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.favFoodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemsCell") as! FoodItemsCell
        let obj = self.favFoodArr[indexPath.row]
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
extension FavFoodController :FavouriteButtonDelegate {
    func addFav(obj:FoodCookModel) {
    }
    
    func deleteFav(cat:String) {
        UserDefaults.standard.removeObject(forKey: "favfoods_\(cat)")
        UserDefaults.standard.synchronize()
        self.fetchAllFav()
        self.delegate?.didChange()
    }


}
