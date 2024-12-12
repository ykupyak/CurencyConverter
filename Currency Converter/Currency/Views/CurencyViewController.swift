//
//  ViewController.swift
//  Currency Converter
//
//  Created by Yaroslav Kupyak on 10.12.2024.
//

import UIKit
import SnapKit

class CurrencyViewController: UIViewController {
    
    // Define constants for UI elements
    private var labelFont: UIFont {
        UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    private let resultFont = UIFont.systemFont(ofSize: 18, weight: .medium)
    private let padding: CGFloat = 20
    private let pickerHeight: CGFloat = 150
    private let textFieldHeight: CGFloat = 50

    // UI Elements
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Amount", comment: "Label for amount input")
        label.font = labelFont
        return label
    }()

    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("Enter Amount", comment: "Placeholder for amount input")
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private lazy var fromCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("From Currency", comment: "Label for source currency picker")
        label.font = labelFont
        return label
    }()

    private lazy var sourceCurrencyPicker = UIPickerView()

    private lazy var toCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("To Currency", comment: "Label for target currency picker")
        label.font = labelFont
        return label
    }()

    private lazy var targetCurrencyPicker = UIPickerView()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Converted Amount: --", comment: "Label for displaying converted amount")
        label.textAlignment = .center
        label.font = resultFont
        label.numberOfLines = 0
        return label
    }()

    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Exchange Rate: --", comment: "Label for displaying exchange rate")
        label.textAlignment = .center
        label.font = labelFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var swapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Swap", comment: "Button title for swapping currencies"), for: .normal)
        button.addTarget(self, action: #selector(swapCurrencies), for: .touchUpInside)
        return button
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
        setupKeyboardDismissRecognizer()
        setupToolbar()
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
        view.addSubview(swapButton)
        view.addSubview(errorLabel) // Add errorLabel to the view

        // Layout using SnapKit
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(textFieldHeight)
        }

        fromCurrencyLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        sourceCurrencyPicker.snp.makeConstraints { make in
            make.top.equalTo(fromCurrencyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(pickerHeight)
        }

        toCurrencyLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceCurrencyPicker.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        targetCurrencyPicker.snp.makeConstraints { make in
            make.top.equalTo(toCurrencyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(pickerHeight)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(targetCurrencyPicker.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rateLabel.snp.bottom).offset(padding)
        }

        swapButton.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(swapButton.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview().inset(padding)
        }
    }
    
    private func setupKeyboardDismissRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Ensures other touch events (e.g., buttons) are still recognized
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        amountTextField.inputAccessoryView = toolbar
    }


    @objc private func dismissKeyboard() {
        view.endEditing(true) // This will dismiss the keyboard for all text inputs in the view
    }
    
    private func setupBindings() {
        viewModel.onConversionResult = { [weak self] result, rate in
            Task { @MainActor in
                self?.activityIndicator.stopAnimating()
                self?.resultLabel.text = String(format: NSLocalizedString("%.4f %@ is equal to %.4f %@", comment: "Conversion result format"), self?.viewModel.amount ?? 0, self?.viewModel.fromCurrency.code ?? "", result, self?.viewModel.toCurrency.code ?? "")
                self?.rateLabel.text = String(format: NSLocalizedString("1 %@ = %.4f %@", comment: "Exchange rate format"), self?.viewModel.fromCurrency.code ?? "", rate, self?.viewModel.toCurrency.code ?? "")
                self?.errorLabel.text = ""
            }
        }

        viewModel.onError = { [weak self] error in
            Task { @MainActor in
                self?.activityIndicator.stopAnimating()
                self?.errorLabel.text = error
            }
        }

        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
    }
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    @objc private func amountChanged() {
        guard let text = amountTextField.text else { return }
        let filteredText = text.filter { "0123456789.".contains($0) }
        if let amount = Double(filteredText), filteredText.count <= 10 {
            viewModel.amount = amount
            amountTextField.text = String(viewModel.amount)
        } else {
            amountTextField.text = String(viewModel.amount)
        }
    }

    @objc private func swapCurrencies() {
        let fromCurrency = viewModel.fromCurrency
        viewModel.setFromCurrency(viewModel.toCurrency)
        viewModel.setToCurrency(fromCurrency)
        sourceCurrencyPicker.selectRow(viewModel.getCurrencies().firstIndex(of: viewModel.fromCurrency) ?? 0, inComponent: 0, animated: true)
        targetCurrencyPicker.selectRow(viewModel.getCurrencies().firstIndex(of: viewModel.toCurrency) ?? 0, inComponent: 0, animated: true)
    }

    private func setupPickers() {
        sourceCurrencyPicker.dataSource = self
        sourceCurrencyPicker.delegate = self
        targetCurrencyPicker.dataSource = self
        targetCurrencyPicker.delegate = self
    }
    
    private func setupDefaultCurrencies() {
        sourceCurrencyPicker.selectRow(0, inComponent: 0, animated: false)
        targetCurrencyPicker.selectRow(1, inComponent: 0, animated: false)
        viewModel.setFromCurrency(viewModel.getCurrencies()[0])
        viewModel.setToCurrency(viewModel.getCurrencies()[1])
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
