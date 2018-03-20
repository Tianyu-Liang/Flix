//
//  Movie.swift
//  Flix
//
//  Created by Tianyu Liang on 3/17/18.
//  Copyright © 2018 Tianyu Liang. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var posterUrl: URL?
    var overview: String
    var releaseDate: String
    var backDropUrl: URL
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        overview = dictionary["overview"] as? String ?? "no overview";
        let posterPathString = dictionary["poster_path"] as! String;
        let baseURLString = "https://image.tmdb.org/t/p/w500";
        posterUrl = URL(string: baseURLString + posterPathString);
        releaseDate = dictionary["release_date"] as! String
        let backDropString = dictionary["backdrop_path"] as! String
        backDropUrl = URL(string: baseURLString + backDropString)!;
        // Set the rest of the properties
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
