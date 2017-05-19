//
//  Movie.swift
//  MovieDB App
//
//  Created by MrDummy on 5/17/17.
//  Copyright © 2017 Huy. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    var id: Int?
    var title: String?
    var poster: String?
    var overview: String?
    var releaseDate: String?
    var image: UIImage?
    
    init(id: Int?, title: String?, poster: String?, overview: String?, releaseDate: String?, image: UIImage?) {
        self.id = id
        self.title = title
        self .poster = poster
        self.overview = overview
        self.releaseDate = releaseDate
        self.image = image
    }
}
