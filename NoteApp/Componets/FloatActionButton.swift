//
//  FloatActionButton.swift
//  TodoList
//
//  Created by Han on 2024/10/1.
//

import UIKit

class FloatActionButton {
    var floatingButton: UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        button.fabAnimation()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor(red: 231/255, green: 224/255, blue: 236/255, alpha: 1))
        return button
    }
}

// UIButton 擴展，讓我們可以設定不同狀態的背景顏色
extension UIButton {
    func fabAnimation() {
        self.layer.cornerRadius = 20
        self.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        self.addTarget(self, action: #selector(handleTap), for: .touchDown)
        self.addTarget(self, action: #selector(handleTouchDown), for: .touchUpInside)
        self.addTarget(self, action: #selector(handleTouchDown), for: .touchUpOutside)
    }
    
    @objc func handleTap() {
        self.backgroundColor = .white.withAlphaComponent(0.6)
        self.tintColor = .black.withAlphaComponent(0.8)
    }
    
    @objc func handleTouchDown() {
        self.backgroundColor = UIColor(cgColor: CGColor(red: 231/255, green: 224/255, blue: 236/255, alpha: 1))
        self.tintColor = .black
    }
}
