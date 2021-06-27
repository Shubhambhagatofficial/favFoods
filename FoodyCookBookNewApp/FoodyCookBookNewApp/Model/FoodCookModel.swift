//
//  FoodCookModel.swift
//  FoodyCookBookNewApp
//
//  Created by Shubham Bhagat on 27/06/21.
//

import Foundation

class FoodCookModel: NSObject {
   
    var idCategory: String?
    var strCategory: String?
    var strCategoryThumb: String?
    var strCategoryDescription :String?
    
    required public init(dict:[String:Any]) {
        self.idCategory = dict["idCategory"] as? String ?? ""
        self.strCategory = dict["strCategory"] as? String ?? ""
        self.strCategoryThumb = dict["strCategoryThumb"] as? String ?? ""
        self.strCategoryDescription = dict["strCategoryDescription"] as? String ?? ""
    }
}
