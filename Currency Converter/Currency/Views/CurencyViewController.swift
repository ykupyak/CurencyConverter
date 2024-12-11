//
//  ViewController.swift
//  Currency Converter
//
//  Created by Yaroslav Kupyak on 10.12.2024.
//

import UIKit
import SnapKit

class CurrencyViewController: UIViewController {
    
    // UI Elements
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let sourceCurrencyPicker = UIPickerView()
    private let targetCurrencyPicker = UIPickerView()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Converted Amount: --"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // ViewModel
    private var viewModel: CurrencyViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Currency Converter"
        setupUI()
        setupBindings()
        viewModel.fetchInitialCurrencies() // Fetch initial data
    }
    
    init(viewModel: CurrencyViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
    
        // Add subviews
        view.addSubview(amountTextField)
        view.addSubview(sourceCurrencyPicker)
        view.addSubview(targetCurrencyPicker)
        view.addSubview(resultLabel)
        view.addSubview(activityIndicator)
        
        // Layout using SnapKit
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        sourceCurrencyPicker.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        targetCurrencyPicker.snp.makeConstraints { make in
            make.top.equalTo(sourceCurrencyPicker.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(targetCurrencyPicker.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
        }
    }
    
    private func setupBindings() {
        // Bind the ViewModel to the View
        viewModel.onConversionResult = { [weak self] result in
            Task { @MainActor in
                self?.activityIndicator.stopAnimating()
                self?.resultLabel.text = "Converted Amount: \(result)"
            }
        }
        
        viewModel.onError = { [weak self] error in
            Task { @MainActor in
                self?.activityIndicator.stopAnimating()
                self?.showErrorAlert(message: error)
            }
        }
        
        // Update ViewModel on input changes
        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
    }
    
    @objc private func amountChanged() {
        guard let text = amountTextField.text, let amount = Double(text) else { return }
        viewModel.amount = amount
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
