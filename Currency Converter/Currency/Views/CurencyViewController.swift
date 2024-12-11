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
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Amount", comment: "Label for amount input")
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("Enter Amount", comment: "Placeholder for amount input")
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let fromCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("From Currency", comment: "Label for source currency picker")
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private let sourceCurrencyPicker = UIPickerView()

    private let toCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("To Currency", comment: "Label for target currency picker")
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private let targetCurrencyPicker = UIPickerView()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Converted Amount: --", comment: "Label for displaying converted amount")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Exchange Rate: --", comment: "Label for displaying exchange rate")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("Currency Converter", comment: "Title of the currency converter screen")
        setupUI()
        setupBindings()
        setupPickers()
        setupDefaultCurrencies()
    }
    
    init(viewModel: CurrencyViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.addSubview(amountLabel)
        view.addSubview(amountTextField)
        view.addSubview(fromCurrencyLabel)
        view.addSubview(sourceCurrencyPicker)
        view.addSubview(toCurrencyLabel)
        view.addSubview(targetCurrencyPicker)
        view.addSubview(resultLabel)
        view.addSubview(rateLabel)
        view.addSubview(activityIndicator)
        
        // Layout using SnapKit
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        fromCurrencyLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        sourceCurrencyPicker.snp.makeConstraints { make in
            make.top.equalTo(fromCurrencyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        toCurrencyLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceCurrencyPicker.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        targetCurrencyPicker.snp.makeConstraints { make in
            make.top.equalTo(toCurrencyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(targetCurrencyPicker.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rateLabel.snp.bottom).offset(20)
        }
    }
    
    private func setupBindings() {
        viewModel.onConversionResult = { [weak self] result, rate in
            Task { @MainActor in
                self?.activityIndicator.stopAnimating()
                self?.resultLabel.text = String(format: NSLocalizedString("%.2f %@ is equal to %.2f %@", comment: "Conversion result format"), self?.viewModel.amount ?? 0, self?.viewModel.fromCurrency.code ?? "", result, self?.viewModel.toCurrency.code ?? "")
                self?.rateLabel.text = String(format: NSLocalizedString("1 %@ = %.2f %@", comment: "Exchange rate format"), self?.viewModel.fromCurrency.code ?? "", rate, self?.viewModel.toCurrency.code ?? "")
            }
        }
        
        viewModel.onError = { [weak self] error in
            Task { @MainActor in
                self?.activityIndicator.stopAnimating()
                self?.resultLabel.text = NSLocalizedString("Conversion failed. Please try again.", comment: "Error message for conversion failure")
                self?.rateLabel.text = ""
            }
        }
                
        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
    }
    
    private func setupPickers() {
        sourceCurrencyPicker.dataSource = self
        sourceCurrencyPicker.delegate = self
        targetCurrencyPicker.dataSource = self
        targetCurrencyPicker.delegate = self
    }
    
    @objc private func amountChanged() {
        guard let text = amountTextField.text, let amount = Double(text) else { return }
        viewModel.amount = amount
    }
    
    private func setupDefaultCurrencies() {
        sourceCurrencyPicker.selectRow(0, inComponent: 0, animated: false)
        targetCurrencyPicker.selectRow(1, inComponent: 0, animated: false)
        viewModel.setFromCurrency(viewModel.getCurrencies()[0])
        viewModel.setToCurrency(viewModel.getCurrencies()[1])
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error alert title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button title"), style: .default))
        present(alert, animated: true)
    }
}

extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getCurrencies().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getCurrencies()[row].displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = viewModel.getCurrencies()[row]
        if pickerView == sourceCurrencyPicker {
            viewModel.setFromCurrency(selectedCurrency)
        } else if pickerView == targetCurrencyPicker {
            viewModel.setToCurrency(selectedCurrency)
        }
    }
}
