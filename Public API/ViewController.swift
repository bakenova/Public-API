//
//  ViewController.swift
//  Public API
//
//  Created by Arailym on 26.03.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var music = itunesMusic()

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: music.previewUrl)
        
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }


}

