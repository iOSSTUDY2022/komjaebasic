//
//  DetailViewController.swift
//  MyMovieChart-1
//
//  Created by 이형주 on 2022/05/17.
//

import Foundation
import UIKit
import WebKit

class DetailViewController: UIViewController{
    
    @IBOutlet weak var wv: WKWebView!
    var mvo: MovieVO!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.wv.navigationDelegate = self
        
        NSLog("title=\(self.mvo.title!)")
        
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        let url = URL(string: self.mvo.moreInfo!)
        let req = URLRequest(url: url!)
        
        self.wv.load(req)
    }
}

// MARK: - WKNavigationDelegate Protocol 구현
extension DetailViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        self.alert("상세페이지를 읽어오지 못했습니다."){
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

}

// MARK: - 심플한 경고창 함수 정의용 익스텐션
extension UIViewController {
    func alert(_ message: String, onClick: (() -> Void)? = nil){
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel){(_) in
            onClick?()
        })
        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
    }
}


