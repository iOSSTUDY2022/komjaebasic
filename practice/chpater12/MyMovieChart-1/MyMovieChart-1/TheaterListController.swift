//
//  TheaterListController.swift
//  MyMovieChart-1
//
//  Created by 이형주 on 2022/05/18.
//

import Foundation
import UIKit

class TheaterListController: UITableViewController{
    var list = [NSDictionary]()
    var startPoint = 0
    
    override func viewDidLoad() {
        self.callTheaterAPI()
    }
    
    func callTheaterAPI() {
        
        let requestURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 100
        let type = "json"
        
        let ur10bj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        
        do {
            let stringData = try NSString(contentsOf: ur10bj!, encoding: 0x80_000_422)
            let encData = stringData.data(using: String.Encoding.utf8.rawValue)
            
            do {
                let apiArray = try JSONSerialization.jsonObject(with: encData!, options: []) as? NSArray
                for obj in apiArray! {
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                let alert = UIAlertController(title: "실패", message: "데이터 분석 실패", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel))
                self.present(alert, animated: true)
            }
            self.startPoint += sList
            
        } catch {
        let alert = UIAlertController(title: "실패", message: "데이터 호출 실패", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        self.present(alert, animated: true)
        }
    
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        
        cell.name?.text = obj["상영관명"] as? String
        cell.tel?.text = obj["연락처"] as? String
        cell.addr?.text = obj["소재지도로명주소"] as? String
        
        return cell
    }
}
