//
//  ViewController.swift
//  dictionary
//
//  Created by Bekpayev Dias on 19.08.2023.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    
    var translationDirection: String = "en-ru"
    
    let myTextField: UITextField = {
        let text = UITextField()
        text.text = "Enter your word"
        text.font = .systemFont(ofSize: 30)
        return text
    }()
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.text = "Your translation"
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    let myButton: UIButton = {
        let button = UIButton()
        button.setTitle("Translate", for: .normal)
        button.configuration = .filled()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    let translationSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.addTarget(self, action: #selector(translationDirectionChanged(_:)), for: .valueChanged)
        return switchControl
    }()
    
    let translationLabel: UILabel = {
        let label = UILabel()
        label.text = "Ru <-> En"
        return label
    }()
    
    let viewHistoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("View History", for: .normal)
        button.addTarget(self, action: #selector(viewHistoryButtonTapped), for: .touchUpInside)
        button.configuration = .filled()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        makeConstraints()
    }
    
    func translateWord(word: String) {
        let apiKey = "dict.1.1.20230819T085404Z.18669022f0a22090.4165f91291af98bc6443e091d7c3be7794b2cf02"
        let url = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup"
        let params: Parameters = [
            "key": apiKey,
            "lang": translationDirection,
            "text": word
        ]
        
        AF.request(url, parameters: params).responseData { response in
            switch response.result {
            case .success(let jsonData):
                do {
                    let decoder = JSONDecoder()
                    let translationResponse = try decoder.decode(TranslationResponse.self, from: jsonData)
                    if let firstTranslation = translationResponse.def.first?.tr.first?.text {
                        self.myLabel.text = firstTranslation
                        self.saveToHistory(word: word, translation: firstTranslation)
                    } else {
                        self.myLabel.text = "Translation not found"
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func buttonTapped() {
        if let word = myTextField.text, !word.isEmpty {
            translateWord(word: word)
        }
    }
    
    @objc func translationDirectionChanged(_ sender: UISwitch) {
        translationDirection = sender.isOn ? "en-ru" : "ru-en"
    }
    
    @objc func viewHistoryButtonTapped() {
        showHistory()
    }
}

extension ViewController {
    
    func setupScene() {
        view.addSubview(myTextField)
        view.addSubview(myLabel)
        view.addSubview(myButton)
        view.addSubview(translationSwitch)
        view.addSubview(translationLabel)
        view.addSubview(viewHistoryButton)
    }
    
    func makeConstraints() {
        myTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-100)
        }
        
        myLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        myButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(100)
        }
        
        translationSwitch.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(150)
        }
        
        translationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(translationSwitch.snp.bottom).offset(16)
        }
        
        viewHistoryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    func saveToHistory(word: String, translation: String) {
        var history = UserDefaults.standard.array(forKey: "TranslationHistory") as? [[String: String]] ?? []
        let entry = ["word": word, "translation": translation]
        history.insert(entry, at: 0)
        UserDefaults.standard.set(history, forKey: "TranslationHistory")
    }
    
    func loadHistory() -> [[String: String]] {
        return UserDefaults.standard.array(forKey: "TranslationHistory") as? [[String: String]] ?? []
    }
    
    func showHistory() {
        let historyVC = HistoryViewController()
        historyVC.history = loadHistory()
        navigationController?.pushViewController(historyVC, animated: true)
    }
}
