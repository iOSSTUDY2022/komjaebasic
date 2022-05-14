//
//  ListViewController.swift
//  MyMovieChart-1
//
//  Created by 이형주 on 2022/05/12.
//

import Foundation
import UIKit

class ListViewController: UITableViewController{

    var page = 1
    
    lazy var list: [MovieVO] = {
        var dataList = [MovieVO]()
        return dataList
    }()
    
    @IBOutlet var moreBtn: UIButton!
    
    @IBAction func more(_ sender: Any) {
        self.page += 1
        self.callMovieAPI()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        self.callMovieAPI()
    }
    
    func callMovieAPI() {
        
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        
        let apiData = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apiData, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("Result = \(log)")
        
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apiData, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.moreInfo = r["linkUrl"] as? String
                mvo.rating = (r["ratingAverage"] as! NSString).doubleValue
                
                self.list.append(mvo)
                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                if (self.list.count >= totalCount) {
                    self.moreBtn.isHidden = true
                }
            }
            
        } catch { }
        
    }
    
    
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

        let url: URL! = URL(string: row.thumbnail!)
        let imageData = try! Data(contentsOf: url)
        cell.thumbnail.image = UIImage(data: imageData)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행 입니다.")
    }
    

    
    
}
