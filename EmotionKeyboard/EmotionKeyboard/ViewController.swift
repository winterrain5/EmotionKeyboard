//
//  ViewController.swift
//  EmotionKeyboard
//
//  Created by 石冬冬 on 16/12/3.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将键盘控制器，添加为当前控制器的子控制器
        addChildViewController(emotionKeyboardVC)
        
        // 将键盘的view设置为控制器的view
        customTextView.inputView = emotionKeyboardVC.view
        
    }

    private lazy var emotionKeyboardVC: CSEmotionKeyboardController = CSEmotionKeyboardController()
   

}

