//
//  FoodItemsCell.swift
//  FoodyCookBookNewApp
//
//  Created by Shubham Bhagat on 27/06/21.
//

import UIKit
import Alamofire
import AlamofireImage

protocol FavouriteButtonDelegate:AnyObject {
    func addFav(obj:FoodCookModel)
    func deleteFav(cat:String)
}

class FoodItemsCell: UITableViewCell {

    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var foodDesc: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    weak var delegate: FavouriteButtonDelegate? = nil
    var isFav:Bool?
    var obj:FoodCookModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(obj:FoodCookModel,isFav:Bool) {
        self.isFav = isFav
        self.obj = obj
        if isFav {
            self.favouriteButton.setImage(UIImage(systemName:"star.fill"), for: .normal)
        } else {
            self.favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        self.foodDesc.text = obj.strCategoryDescription
        self.foodName.text = obj.strCategory
        if let url = obj.strCategoryThumb {
            AF.request(url).responseImage { response in
                if case .success(let image) = response.result {
                    self.imgView.image = image
                }
            }
        }
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        if let isFav = self.isFav , let objs = self.obj{
            if isFav {
                self.delegate?.deleteFav(cat: objs.idCategory ?? "")
            } else {
                self.delegate?.addFav(obj: objs)
            }
        }
    }
}
