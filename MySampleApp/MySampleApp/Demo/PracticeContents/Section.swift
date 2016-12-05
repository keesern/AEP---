//
//  Section.swift
//  MySampleApp
//
//  Created by Kee Sern on 11/16/16.
//
//

import Foundation
struct Section {
    
    var heading : String
    var items : [String]
    var storyBoard : String
    var icon: String

    init(title: String, objects : [String],icon: String, storyBoard: String) {
        
        self.heading = title
        self.items = objects
        self.storyBoard = storyBoard
        self.icon = icon
    }
    

}
