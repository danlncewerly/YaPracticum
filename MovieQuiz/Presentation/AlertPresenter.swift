//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Данил Красноперов on 21.06.2024.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func showAlert(model: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
