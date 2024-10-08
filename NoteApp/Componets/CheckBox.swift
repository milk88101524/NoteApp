//
//  CheckBox.swift
//  TodoList
//
//  Created by Han on 2024/10/1.
//

import UIKit

class CheckBox {
    var isChecked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    // 保持一個固定的 UIButton 實例
    private let checkBoxButton: UIButton
    
    init() {
        checkBoxButton = UIButton()
        checkBoxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkBoxButton.tintColor = .black
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        updateImage() // 初始化時更新圖像
    }
    
    // 更新按鈕圖像，依據 isChecked 狀態
    private func updateImage() {
        let imageName = isChecked ? "checkmark.square.fill" : "square"
        checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // 返回已存在的按鈕實例
    var checkBox: UIButton {
        return checkBoxButton
    }
}


#Preview {
    CheckBox().checkBox
}
