//
//  ViewController.swift
//  Check Time
//
//  Created by Dang Luan on 2024/09/19.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var startTimeTF: UITextField!
    @IBOutlet var endTimeTF: UITextField!
    @IBOutlet var checkTimeTF: UITextField!
    @IBOutlet var checkBtn: UIButton!
    let homeModel = HomeViewModel()
    var cancellable: AnyCancellable?
    let refreshControl = UIRefreshControl()
    
    var startTime: Int16 = -1;
    var endTime: Int16 = -1;
    var checkTime: Int16 = -1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ホーム"
        homeModel.getAllTimeCheckeds()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 95
        tableView.rowHeight = UITableView.automaticDimension
        
        startTimeTF.delegate = self
        endTimeTF.delegate = self
        checkTimeTF.delegate = self
        startTimeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        endTimeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        checkTimeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cancellable = homeModel.$timeCheckedes.sink() {
            print ("changeData: \($0.count)")
            self.tableView.reloadData()
        }
        
        // close keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func checkAction(_ sender: UIButton) {
        dismissKeyboard()
        homeModel.checkData(startTime: startTime, endTime: endTime, checkTime: checkTime)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeModel.timeCheckedes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCheckTableViewCell", for: indexPath) as? TimeCheckTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let data = homeModel.timeCheckedes[indexPath.row]
        cell.setup(data: data)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}


extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if(updatedText.isEmpty) {
                return true
            }
            if let newTime = Int(updatedText), newTime >= 0, newTime <= 23 {
                return true;
            }
        }
        return false
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let newText = textField.text, let newTime = Int16(newText) else {
            return
        }
        
        switch textField {
        case startTimeTF:
            startTime = newTime
            break
            
        case endTimeTF:
            endTime = newTime
            break
            
        case checkTimeTF:
            checkTime = newTime
            break
            
        default:
            break
        }
    }
}

