//
//  EditNoteViewController.swift
//  TodoList
//
//  Created by Han on 2024/10/8.
//

import UIKit

class EditNoteViewController: UIViewController {
    var note: NoteModel?
    
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
        
        guard let note else {
            print("Note is nil")
            return
        }
        contentTextField.text = note.content
        contentTextField.textColor = .black
        print(note)
        
        // 監聽鍵盤顯示與隱藏事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupView() {
        guard let note = note else {
            print("Note is nil")
            return
        }
        navigationItem.title = note.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        view.backgroundColor = .white
        
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
            if ((self.coreDataConnect?.updateNoteContent(id: note!.id, content: contentTextField.text)) != nil) {
                print("Edit Note Success")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Faile to Edit Note")
            }
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

#Preview {
    EditNoteViewController()
}
