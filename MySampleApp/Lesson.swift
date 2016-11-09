//
//  Lessons.swift
//  MySampleApp
//
//  Created by Raymond Zou on 10/30/16.
//
//

import Foundation
struct Lesson {
    var name: String
    var level: String
    var imageName: String
}

struct TIBLessons {
    static func getAllLessons() -> [Lesson] {
        return [
            Lesson(name: "Lesson1", level: "beginner", imageName: "1"),
            Lesson(name: "Lessons2", level: "beginner",
                imageName: "2"),
            Lesson(name: "Lesson3", level: "intermedia",
                imageName: "3"),
            Lesson(name: "Lesson4", level: "hard",
                imageName: "4")
        ]
    }
}
