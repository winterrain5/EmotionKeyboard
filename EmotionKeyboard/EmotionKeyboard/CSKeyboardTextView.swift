//
//  CSKeyboardTextView.swift
//  EmotionKeyboard
//
//  Created by 石冬冬 on 16/12/24.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSKeyboardTextView: UITextView {

    internal func insertEmoticon(emoticon:CSKeyboardEmoticons) {
        // emoji图文混排
        if let tempEmojiStr = emoticon.emoticonStr {
            // 取出光标所在的位置
            let range =  selectedTextRange!
            // 用emoji表情替换光标所在的位置
             replaceRange(range, withText: tempEmojiStr)
            return
        }
        
        // 默认和浪小花图文混排
        if let tempPngPath = emoticon.pngPath {
            
            // 通过textView中的属性文字创建属性字符串
            let attrMstr = NSMutableAttributedString(attributedString:  attributedText)
            
            // 创建图片的属性字符串
            let attachment  = CSKeyboardAttachment()
            attachment.emoticonChs = emoticon.chs
            let lineHeight =  font!.lineHeight
            attachment.bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
            attachment.image = UIImage(contentsOfFile: tempPngPath)
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            // 取出光标所在的位置
            let range =  selectedRange
            
            // 用emoji表情替换光标所在的位置
            attrMstr.replaceCharactersInRange(range, withAttributedString: imageAttrStr)
            
            // 显示可变字符串
             attributedText = attrMstr
            
            // 确定光标的位置
             selectedRange = NSRange(location: range.location + 1, length: 0)
            
            // 重新设置字体大小
             font = UIFont.systemFontOfSize(17.0)
            return
        }
        
        // 删除最近一个文字或者表情
        if emoticon.isRemoveButton {
             deleteBackward()
        }
    }
    
    internal func emoticonStr() -> String {
        let range = NSRange(location: 0, length: attributedText.length)
        var strM = String()
        attributedText.enumerateAttributesInRange(range, options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            if let tempAttachment = dict["NSAttachment"] as? CSKeyboardAttachment {
                strM += tempAttachment.emoticonChs!
            } else {
                strM += (self.text as NSString).substringWithRange(range)
            }
            
        }
        return strM
    }

}
