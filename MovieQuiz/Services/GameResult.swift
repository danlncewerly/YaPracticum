//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Данил Красноперов on 19.06.2024.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
