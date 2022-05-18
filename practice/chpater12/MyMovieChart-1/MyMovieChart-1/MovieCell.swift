//
//  MovieCell.swift
//  MyMovieChart-1
//
//  Created by 이형주 on 2022/05/12.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell{
    
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var thumbnail: UIImageView!
}
