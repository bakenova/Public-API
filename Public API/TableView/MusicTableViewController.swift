//
//  MusicTableViewController.swift
//  Public API
//
//  Created by Arailym on 26.03.2022.
//

import UIKit
import SDWebImage
import Alamofire
import SVProgressHUD
import SwiftyJSON

class MusicTableViewController: UITableViewController, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var musicList = [itunesMusic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "Search artist"
        navigationItem.searchController = searchController
        
        searchMusic(term: "Eminem")
    }
    
//  MARK: - Searching
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        musicList.removeAll()
        tableView.reloadData()
        searchMusic(term: searchBar.text!)
    }
    
    func searchMusic(term: String) {
        let parameters = ["term": term,
                          "limit": 25] as [String: Any]
        AF.request("https://itunes.apple.com/search?term=jack+johnson&limit=25", method: .get, parameters: parameters).responseJSON { response in
            if response.response?.statusCode == 200 {
                let json = JSON(response.value!)
                
                if let array = json["results"].array {
                    for item in array {
                        let music = itunesMusic(json: item)
                        self.musicList.append(music)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musicList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! MusicTableViewCell
        cell.artistNameLabel.text = musicList[indexPath.row].artistName
        cell.trackNameLabel.text = musicList[indexPath.row].trackName
        cell.artworkImageView.sd_setImage(with: URL(string: musicList[indexPath.row].artworkUrl100), completed: nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.music = musicList[indexPath.row]
        navigationController?.show(vc, sender: self)
    }
}
