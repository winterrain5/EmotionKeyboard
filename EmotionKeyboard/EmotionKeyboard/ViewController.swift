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
    
  
    @IBAction func itemClick(sender: AnyObject) {
        
        let range = NSRange(location: 0, length: customTextView.attributedText.length)
        var strM = String()
        customTextView.attributedText.enumerateAttributesInRange(range, options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            if let tempAttachment = dict["NSAttachment"] as? CSKeyboardAttachment {
                strM += tempAttachment.emoticonChs!
            } else {
                strM += (self.customTextView.text as NSString).substringWithRange(range)
            }
            
        }
        print(strM)
    }
    
    private lazy var emotionKeyboardVC: CSEmotionKeyboardController = CSEmotionKeyboardController {[unowned self] (emoticon) -> () in
        // emoji图文混排
        if let tempEmojiStr = emoticon.emoticonStr {
            // 取出光标所在的位置
            let range = self.customTextView.selectedTextRange!
            // 用emoji表情替换光标所在的位置
            self.customTextView.replaceRange(range, withText: tempEmojiStr)
            return
        }
        
        // 默认和浪小花图文混排
        if let tempPngPath = emoticon.pngPath {
            
            // 通过textView中的属性文字创建属性字符串
            let attrMstr = NSMutableAttributedString(attributedString: self.customTextView.attributedText)
            
            // 创建图片的属性字符串
            let attachment  = CSKeyboardAttachment()
            attachment.emoticonChs = emoticon.chs
            let lineHeight = self.customTextView.font!.lineHeight
            attachment.bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
            attachment.image = UIImage(contentsOfFile: tempPngPath)
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            // 取出光标所在的位置
            let range = self.customTextView.selectedRange
            
            // 用emoji表情替换光标所在的位置
            attrMstr.replaceCharactersInRange(range, withAttributedString: imageAttrStr)
            
            // 显示可变字符串
            self.customTextView.attributedText = attrMstr
            
            // 确定光标的位置
              self.customTextView.selectedRange = NSRange(location: range.location + 1, length: 0)
            
            // 重新设置字体大小
            self.customTextView.font = UIFont.systemFontOfSize(17.0)
            return
        }
        
        // 删除最近一个文字或者表情
        if emoticon.isRemoveButton {
            self.customTextView.deleteBackward()
        }
    }
   

}

