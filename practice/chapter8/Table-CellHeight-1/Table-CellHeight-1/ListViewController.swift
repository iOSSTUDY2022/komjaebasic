//
//  ListViewController.swift
//  Table-CellHeight-1
//
//  Created by 이형주 on 2022/05/12.
//

import Foundation
import UIKit

class ListViewController: UITableViewController{
    
    var list = [String]()
    
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "목록입력", message: "추가될 글을 작성해주세용", preferredStyle: .alert)
        alert.addTextField() { (tf) in
            tf.placeholder = "내용을 입력하세용"
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default){ (_) in
            if let title = alert.textFields?[0].text {
                self.list.append(title)
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    


    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = self.list[indexPath.row]
        let height = CGFloat(60 + (row.count / 30) * 20)
        return height
    }
    
}
