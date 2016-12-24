//
//  ViewController.swift
//  EmotionKeyboard
//
//  Created by 石冬冬 on 16/12/3.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customTextView: CSKeyboardTextView!
   
    @IBOutlet weak var showLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将键盘控制器，添加为当前控制器的子控制器
        addChildViewController(emotionKeyboardVC)
        
        // 将键盘的view设置为控制器的view
        customTextView.inputView = emotionKeyboardVC.view
        
    }
    
  
    @IBAction func itemClick(sender: AnyObject) {
        
        print(self.customTextView.emoticonStr())
        showLabel.text = self.customTextView.emoticonStr()
    }
    
    private lazy var emotionKeyboardVC: CSEmotionKeyboardController = CSEmotionKeyboardController {[unowned self] (emoticon) -> () in
        self.customTextView.insertEmoticon(emoticon)

    }
   

}

