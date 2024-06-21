import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceProtocol!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statisticService = StatisticService()
        self.statisticService = statisticService
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        self.alertPresenter = AlertPresenter(viewController: self)
        self.questionFactory?.requestNextQuestion()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        currentQuestionIndex = 0
        correctAnswers = 0
        
       
    }

    
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    //MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        print("noButtonClicked called")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        print("yesButtonClicked called")
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        sender.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 20)
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        print("convert(model:) called with model: \(model)")
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    private func changeStateButton(_ isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    
    private func showNextQuestionOrResults() {
        print("showNextQuestionOrResults called")
        
        guard let statisticService = statisticService else {
            print("Error: statisticService is nil")
            return
        }
        
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let dateText = formatDate(bestGame.date)
            let text = """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateText))
Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
"""
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    self?.resetGame()
                }
            )
            alertPresenter?.showAlert(model: alertModel)
        } else {
            imageView.layer.borderColor = UIColor.clear.cgColor
            
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
            print("requestNextQuestion called")
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
           if isCorrect {
               correctAnswers += 1
           }
           imageView.layer.masksToBounds = true
           imageView.layer.borderWidth = 8
           imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               self.showNextQuestionOrResults()
           }
       }
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel=AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) {[weak self] in
            self?.resetGame()
        }
        alertPresenter?.showAlert(model: alertModel)
    }
    private func resetGame() {

        print("resetGame called")
        currentQuestionIndex = 0
        correctAnswers = 0
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        configureImageView()
        
        questionFactory?.requestNextQuestion()
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func configureImageView() {
        print("configureImageView called")
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
    }

    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
}

