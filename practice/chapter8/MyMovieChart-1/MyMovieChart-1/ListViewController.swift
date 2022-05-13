//
//  ListViewController.swift
//  MyMovieChart-1
//
//  Created by 이형주 on 2022/05/12.
//

import Foundation
import UIKit

class ListViewController: UITableViewController{
    
    var dataSet = [
    ("다크나이트", "어쩌고저쩌고", "2008-09-10", 8.95, "darknight.jpg"),
    ("howoo", "어쩌고저쩌고2", "2008-10-10", 7.33, "rain.jpg"),
    ("The Secret", "어쩌고저쩌고3", "2010-10-10", 5.95, "secret.jpg")
    ]
    
    lazy var list: [MovieVO] = {
        var dataList = [MovieVO]()
        for (title, desc, releaseDate, rating, thumbnail) in self.dataSet {
            let mvo = MovieVO()
            mvo.title = title
            mvo.description = desc
            mvo.releaseDate = releaseDate
            mvo.rating = rating
            mvo.thumbnail = thumbnail
            
            dataList.append(mvo)
        }
        return dataList
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.releaseDate?.text = row.releaseDate
        cell.rating?.text = "\(row.rating!)"
        cell.thumbnail.image = UIImage(named: row.thumbnail!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행 입니다.")
    }
    
    override func viewDidLoad() {
    }
    
    
}
