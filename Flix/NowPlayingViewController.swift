//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Tianyu Liang on 2/7/18.
//  Copyright © 2018 Tianyu Liang. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    var searchArray: [[String: Any]] = [];
    var movies: [[String: Any]] = [];
  
    var refreshControl: UIRefreshControl!
    
    // search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        searchBar.delegate = self;
        refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector (NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = 180;
        fetchMovies();
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        activityIndicator.startAnimating();
        fetchMovies();
        activityIndicator.stopAnimating();
    }
    
    func fetchMovies(){
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!;
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main);
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error{
                print(error.localizedDescription);
            }else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any];
                let movies = dataDictionary["results"] as! [[String: Any]];
                self.movies = movies;
                self.searchArray = movies;
                self.tableView.reloadData();
                self.refreshControl.endRefreshing();
            }
        }
        task.resume();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell;
        let movie = searchArray[indexPath.row];
        let title = movie["title"] as! String;
        let overview = movie["overview"] as! String;
        cell.titleLabel.text = title;
        cell.overviewLabel.text = overview;
        let posterPathString = movie["poster_path"] as! String;
        let baseURLString = "https://image.tmdb.org/t/p/w500";
        let posterURL = URL(string: baseURLString + posterPathString);
        cell.posterImageView.af_setImage(withURL: posterURL!);
        return cell;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        tapRecognizer.isEnabled = true;
        if(searchText.isEmpty){
            searchArray = movies;
        }
        else{
            searchArray = [];
            for item in movies {
                if ((item["title"] as! String).lowercased().contains(searchText.lowercased())){
                    searchArray.append(item);
                }
            }
        }
        
        
        
        
        
        tableView.reloadData();
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        searchBar.text = "";
        searchBar.resignFirstResponder();
        searchArray = movies;
        tableView.reloadData();
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    
    @IBAction func clicked(_ sender: Any) {
        tapRecognizer.isEnabled = false;
        self.view.endEditing(true);
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
