//
//  AddNoteViewController.swift
//  TodoList
//
//  Created by Han on 2024/10/7.
//

import UIKit

class AddNoteViewController: UIViewController {
    // MARK: Set Core Data
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var coreDataConnect: CoreDataConnect? = nil
    
    let contentTextField: PaddingTextView = {
        let textField = PaddingTextView()
        textField.font = .preferredFont(forTextStyle: .body)
        textField.textColor = .label
        textField.text = "Enter note..."
        textField.textColor = UIColor.lightGray
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        return textField
    }()
    
    // 用來控制 contentTextField 底部的約束
    var contentTextFieldBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        coreDataConnect = CoreDataConnect(context: moc)
        setupView()
        
        // 監聽鍵盤顯示與隱藏事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupView() {
        navigationItem.title = "Add Note"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        view.backgroundColor = .white
        
        contentTextField.delegate = self
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                contentTextField,
            ])
            stackView.axis = .vertical
            stackView.spacing = 16
            stackView.distribution = .fill
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            return stackView
        }()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        
        contentTextFieldBottomConstraint = mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentTextFieldBottomConstraint // 設定 contentTextField 的底部約束
        ])
    }
    
    @objc func saveButtonTapped() {
        if (contentTextField.text != "Enter note..." && contentTextField.text != "") {
            let alert = UIAlertController(title: "Add Title", message: "Enter note title", preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                guard let textField = alert.textFields?.first,
                      let title = textField.text
                else { return }
                print(self.contentTextField.text ?? "")
                if ((self.coreDataConnect?.createNote(title: title, content: self.contentTextField.text)) != nil) {
                    
                    print("Create Note Success")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    Snackbar.show(message: "Faile to Create Note", in: self.view)
                    print("Faile to Create Note")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Note nil", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    // 鍵盤顯示時調整 contentTextField 的位置
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            // 調整 contentTextField 的底部約束
            contentTextFieldBottomConstraint.constant = -keyboardHeight + view.safeAreaInsets.bottom
            
            // 使用動畫來更新佈局
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // 鍵盤隱藏時恢復 contentTextField 的位置
    @objc func keyboardWillHide(notification: NSNotification) {
        contentTextFieldBottomConstraint.constant = 0
        
        // 使用動畫來更新佈局
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        // 移除通知監聽
        NotificationCenter.default.removeObserver(self)
    }
}

extension AddNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter note..."
            textView.textColor = UIColor.lightGray
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // 設置手勢給 navigationBar
        if let navigationBar = navigationController?.navigationBar {
            let navBarTap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            navigationBar.addGestureRecognizer(navBarTap)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

#Preview {
    AddNoteViewController()
}
