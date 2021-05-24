//
//  MarvelViewViewModel.swift
//  Marvelgram_but_In_RxSwift
//
//  Created by Дмитрий Жучков on 15.05.2021.
//

import Foundation
struct MarvelViewViewModel {
    
    private var marvel: MarvelJSON
    
    
    init(marvel: MarvelJSON) {
        self.marvel = marvel
    }
    // MARK: Hero info
    var posterURL: URL {
        let urlString = marvel.thumbnail.path + "/detail.jpg"
        return URL(string:urlString)!
    }
    var name: String {
        let name = marvel.name
        return name
    }
    var title: String {
        let title = marvel.marvelJSONDescription
        return title
    }
}
