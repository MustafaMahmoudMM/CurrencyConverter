//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 16/09/2021.
//

import UIKit

enum CurrencyType: String {
    case eur = "EUR"
    case usd = "USD"
    case jpy = "JPY"
}

class ExchangingCurrencyViewController: UIViewController {

    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var sellText: UITextField!
    @IBOutlet weak var receiveText: UITextField!
    @IBOutlet weak var sellFromLabel: UILabel!
    @IBOutlet weak var receiveToLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var eurBalance: Double = 0.00
    var usdBalance: Double = 0.00
    var jpyBalance: Double = 0.00
    var exchangingCount: Int = 0
    
    var selectedSellCurrencyType: CurrencyType = .eur
    var selectedReceiveCurrencyType: CurrencyType = .usd
    
    var presenter: ExchangingCurrencyPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkExistedBalances()
        setupNavigationBar()
        setupView()
        self.presenter = ExchangingCurrencyPresenter(view: self)
    }
    
    /// setup Navigation Bar (title & colors)
    func setupNavigationBar() {
        self.title = "Currency Converter"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 145/255.0, blue: 214/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    /// get the started banlance for each currency type
    func checkExistedBalances() {
        eurBalance = UserDefaults.standard.object(forKey: "EUR") != nil ? UserDefaults.standard.double(forKey: "EUR") : 1000.00
        UserDefaults.standard.set(eurBalance, forKey: "EUR")
        usdBalance = UserDefaults.standard.double(forKey: "USD")
        jpyBalance = UserDefaults.standard.double(forKey: "JPY")
        exchangingCount = UserDefaults.standard.integer(forKey: "ExchangingCount")
    }
    
    /// setup intial view
    func setupView() {
        eurLabel.text = "\(String(format:"%.2f", eurBalance)) \(CurrencyType.eur.rawValue)"
        usdLabel.text = "\(String(format:"%.2f", usdBalance)) \(CurrencyType.usd.rawValue)"
        jpyLabel.text = "\(String(format:"%.2f", jpyBalance)) \(CurrencyType.jpy.rawValue)"
        sellFromLabel.text = selectedSellCurrencyType.rawValue
        receiveToLabel.text = selectedReceiveCurrencyType.rawValue
        hideProgressBar()
    }

    /// display action sheet to allaw user to select currency type
    func displayActionSheetToSelectCurrency (isForSell: Bool = false) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for currency in [CurrencyType.eur, CurrencyType.usd, CurrencyType.jpy] {
            let currencyActionButton = UIAlertAction(title: currency.rawValue, style: .default) { action -> Void in
                if isForSell {
                    self.sellFromLabel.text = currency.rawValue
                    self.selectedSellCurrencyType = currency
                } else {
                    self.receiveToLabel.text = currency.rawValue
                    self.selectedReceiveCurrencyType = currency
                }
            }
            actionSheetController.addAction(currencyActionButton)
        }

        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func selectSellType(_ sender: UITapGestureRecognizer) {
        displayActionSheetToSelectCurrency(isForSell: true)
    }
    
    @IBAction func selectReceiveType(_ sender: UITapGestureRecognizer) {
        displayActionSheetToSelectCurrency()
    }
    
    @IBAction func submit(_ sender: UIButton) {
        presenter.exchangeCurrency(amount: sellText.text ?? "", from: selectedSellCurrencyType, to: selectedReceiveCurrencyType)
        receiveText.text = ""
    }
}

/// confirm ExchangingCurrencyViewControllerProtocol
extension ExchangingCurrencyViewController: ExchangingCurrencyViewControllerProtocol {
    func updateReceivedAmount(with exchangeCurrencyModel: ExchangingCurrencyModel){
        if let amount = Double(exchangeCurrencyModel.amount ?? "") {
            DispatchQueue.main.async {
                self.receiveText.text = "+ \(String(format:"%.2f", amount))"
                // handle adding converted amount
                if self.selectedReceiveCurrencyType == .eur {
                    self.eurBalance += amount
                    self.eurLabel.text = "\(String(format:"%.2f", self.eurBalance)) \(CurrencyType.eur.rawValue)"
                    UserDefaults.standard.set(self.eurBalance, forKey: "EUR")
                } else if self.selectedReceiveCurrencyType == .usd {
                    self.usdBalance += amount
                    self.usdLabel.text = "\(String(format:"%.2f", self.usdBalance)) \(CurrencyType.usd.rawValue)"
                    UserDefaults.standard.set(self.usdBalance, forKey: "USD")
                } else {
                    self.jpyBalance += amount
                    self.jpyLabel.text = "\(String(format:"%.2f", self.jpyBalance)) \(CurrencyType.jpy.rawValue)"
                    UserDefaults.standard.set(self.jpyBalance, forKey: "JPY")
                }
                
                // handle reducing converted amount
                let commissionFee = self.exchangingCount > 4 ? 0.007 : 0.0
                if self.selectedSellCurrencyType == .eur {
                    self.eurBalance -= Double(self.sellText.text ?? "") ?? 0.0 + ((Double(self.sellText.text ?? "") ?? 0.0) * commissionFee)
                    self.eurLabel.text = "\(String(format:"%.2f", self.eurBalance)) \(CurrencyType.eur.rawValue)"
                    UserDefaults.standard.set(self.eurBalance, forKey: "EUR")
                } else if self.selectedSellCurrencyType == .usd {
                    self.usdBalance -= Double(self.sellText.text ?? "") ?? 0.0 + ((Double(self.sellText.text ?? "") ?? 0.0) * commissionFee)
                    self.usdLabel.text = "\(String(format:"%.2f", self.usdBalance)) \(CurrencyType.usd.rawValue)"
                    UserDefaults.standard.set(self.usdBalance, forKey: "USD")
                } else {
                    self.jpyBalance -= Double(self.sellText.text ?? "") ?? 0.0 + ((Double(self.sellText.text ?? "") ?? 0.0) * commissionFee)
                    self.jpyLabel.text = "\(String(format:"%.2f", self.jpyBalance)) \(CurrencyType.jpy.rawValue)"
                    UserDefaults.standard.set(self.jpyBalance, forKey: "JPY")
                }
                
                self.exchangingCount += 1
                UserDefaults.standard.set(self.exchangingCount, forKey: "ExchangingCount")
                self.displayAlert(title: "Currency Converted", message: "You have converted \(String(format:"%.2f", Double(self.sellText.text ?? "") ?? 0.0)) \(self.selectedSellCurrencyType.rawValue) to \(String(format:"%.2f", amount)) \(self.selectedReceiveCurrencyType.rawValue). Commission Fee - \(String(format:"%.2f", (Double(self.sellText.text ?? "") ?? 0.0) * commissionFee)) \(self.selectedSellCurrencyType.rawValue).")
                self.sellText.text = ""
            }
        } else {
            displayAlert(title: "Currency Can't Converted", message: "Oops, there's something wrong!.")
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneActionButton = UIAlertAction(title: "Done", style: .cancel) { action -> Void in
            print("Cancel")
        }
        alertController.addAction(doneActionButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showProgressBar() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.indicator.startAnimating()
        }
    }
    
    func hideProgressBar() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.indicator.stopAnimating()
        }
    }
}
