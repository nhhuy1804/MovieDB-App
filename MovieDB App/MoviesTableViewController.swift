//
//  MoviesTableViewController.swift
//  MovieDB App
//
//  Created by MrDummy on 5/17/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        loadMovieList()
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredMovies = movies.filter { movie in
            return (movie.title?.lowercased().contains(searchText.lowercased()))!
        }
        
        tableView.reloadData()
    }
    
    func loadMovieList() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=3be5ee3494a1c54f6055ae8aa354f1a4")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask: URLSessionDataTask? = session.dataTask(with: url! as URL) {
            data, response, error in
            
            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            if let httpURLRes = response as? HTTPURLResponse {
                
                if httpURLRes.statusCode == 200 {
                    do {
                        if let data = data, let response = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                            
                            if let array: AnyObject = response["results"] {
                                
                                for movieDictonary in array as! [AnyObject] {
                                    if let movieDictonary = movieDictonary as? [String: AnyObject], let title = movieDictonary["title"] as? String {
                                        
                                        let id_movie = movieDictonary["id"] as? Int
                                        let poster = movieDictonary["poster_path"] as? String
                                        let overview = movieDictonary["overview"] as? String
                                        let releaseDate = movieDictonary["release_date"] as? String
                                        
                                        self.movies.append(Movie(id: id_movie, title: title, poster: poster, overview: overview, releaseDate: releaseDate, image: #imageLiteral(resourceName: "noimg")))
                                    } else {
                                        
                                        print("Not a dictionary")
                                        
                                    }
                                }
                            } else {
                                
                                print("Results key not found in dictionary")
                                
                            }
                        } else {
                            
                            print("JSON Error")
                            
                        }
                    } catch let error as NSError {
                        print("Error parsing results: \(error.localizedDescription)")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                }
            }
        }
        
        dataTask?.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMovies.count
        }
        
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie: Movie
        if searchController.isActive && searchController.searchBar.text != "" {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        cell.imageView?.image = #imageLiteral(resourceName: "noimg")
        OperationQueue().addOperation { () -> Void in
            if let img = Downloader.downloadImageWithURL("https://image.tmdb.org/t/p/w320\(movie.poster!)") {
                OperationQueue.main.addOperation({
                    self.movies[indexPath.row].image = img
                    cell.imageView?.image = img
                })
            }
        }
        
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.overview
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil {
            
            let movieDetailVC = segue.destination as! MovieDetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                    
                movieDetailVC.id = movies[indexPath.row].id!
                movieDetailVC.image = movies[indexPath.row].image!
            }
        }
    }
}

class Downloader {
    class func downloadImageWithURL(_ url:String) -> UIImage! {
        let data = try? Data(contentsOf: URL(string: url)!)
        return UIImage(data: data!)
    }
}

extension MoviesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

