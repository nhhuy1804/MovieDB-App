//
//  MovieDetailViewController.swift
//  MovieDB App
//
//  Created by MrDummy on 5/17/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet weak var lblBudget: UILabel!
    @IBOutlet weak var lblRevenue: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    var image: UIImage?
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadMovieDetail()
        imgMovie.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMovieDetail() {
        
        if let idMovie = id {
            
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(idMovie)?api_key=3be5ee3494a1c54f6055ae8aa354f1a4")
            
            var detail = [String:Any]()
            
            let request = NSMutableURLRequest(url: url! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
            request.httpMethod = "GET"
            
            _ = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (Data, URLResponse, Error) in
                if (Error != nil) {
                    print(Error!)
                } else {
                    do {
                        detail = try JSONSerialization.jsonObject(with: Data!, options: .allowFragments) as! [String:Any]
                        DispatchQueue.main.async {
                            
                            self.lblTitle.text = detail["title"]! as? String
                            self.lblReleaseDate.text = detail["release_date"] as? String
                            
                            if let vote = detail["vote_average"] {
                                self.lblVote.text = "\(vote)"
                            }
                            if let budget = detail["budget"] {
                                self.lblBudget.text = "\(budget)$"
                            }
                            if let revenue = detail["revenue"] {
                                self.lblRevenue.text = "\(revenue)$"
                            }
                            if let overview = detail["overview"] {
                                self.lblOverview.text = "Overview: \(overview)"
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }).resume()
        }
    }

}
