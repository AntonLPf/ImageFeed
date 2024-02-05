//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 05.02.24.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!  //1
//        urlComponents.queryItems = [
//           URLQueryItem(name: "client_id", value: AccessKey),                  //2
//           URLQueryItem(name: "redirect_uri", value: RedirectURI),             //3
//           URLQueryItem(name: "response_type", value: "code"),                 //4
//           URLQueryItem(name: "scope", value: AccessScope)                     //5
//         ]
//         let url = urlComponents.url!                                            //6
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) { 
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
