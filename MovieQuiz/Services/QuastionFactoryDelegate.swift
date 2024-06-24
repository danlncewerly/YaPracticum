//
//  QuastionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Данил Красноперов on 19.06.2024.
//
import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
