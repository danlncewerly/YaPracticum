//
//  StaticService.swift
//  MovieQuiz
//
//  Created by Данил Красноперов on 19.06.2024.
//
import Foundation

final class StatisticService {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case totalCorrectAnswers
        case totalQuestions
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
    }
}

extension StatisticService: StatisticServiceProtocol {
    func store(correct count: Int, total amount: Int) {
        let totalCorrectAnswers = storage.integer(forKey: Keys.correct.rawValue)
        let totalQuestions = storage.integer(forKey: Keys.totalQuestions.rawValue)
        storage.set(totalCorrectAnswers + count, forKey: Keys.correct.rawValue)
        storage.set(totalQuestions + amount, forKey: Keys.totalQuestions.rawValue)
        gamesCount += 1
        let currentBestGame = bestGame
        if count > currentBestGame.correct || (count == currentBestGame.correct && amount < currentBestGame.total) {
            let newBestGame = GameResult(correct: count, total: amount, date: Date())
            bestGame = newBestGame
        }
    }
    
    var gamesCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "gamesCount")
        }
        set { UserDefaults.standard.set(newValue, forKey: "gamesCount") }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: "bestGameCorrect")
            let total = storage.integer(forKey: "bestGameTotal")
            let date = storage.object(forKey: "bestGameDate") as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: "bestGameCorrect")
            storage.set(newValue.total, forKey: "bestGameTotal")
            storage.set(newValue.date, forKey: "bestGameDate")
        }
    }
    
    var totalAccuracy: Double {
        get {
            let totalCorrectAnswers = storage.integer(forKey: "totalCorrectAnswers")
            let totalQuestions = storage.integer(forKey: "totalQuestions")
            
            guard totalQuestions != 0 else { return 0.0 }
            return (Double(totalCorrectAnswers) / Double(totalQuestions)) * 100
        }
    }
}
