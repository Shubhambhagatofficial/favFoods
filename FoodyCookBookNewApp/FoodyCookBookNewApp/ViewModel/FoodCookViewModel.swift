//
//  FoodCookViewModel.swift
//  FoodyCookBookNewApp
//
//  Created by Shubham Bhagat on 27/06/21.
//

import Foundation
import Alamofire

class FoodCookViewModel {
    
    
    func getFoodItems(completion: @escaping ([FoodCookModel])->Void) {
        var foodarray = [FoodCookModel]()
        
        AF.request("https://www.themealdb.com/api/json/v1/1/categories.php").responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                if let objJson = value as? [String:Any] {
                    if let data = objJson["categories"] as? NSArray {
                    if data.count > 0 {
                        for items in data {
                            if let  dict = items as? [String:Any] {
                                foodarray.append(FoodCookModel.init(dict: dict))
                            }
                        }
                    }
                    }
                }
                completion(foodarray)
            case .failure(_):
                completion(foodarray)
            }
            
        })
    }
    
}
