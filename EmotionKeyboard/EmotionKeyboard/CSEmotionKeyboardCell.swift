//
//  CSEmotionKeyboardCell.swift
//  EmotionKeyboard
//
//  Created by 石冬冬 on 16/12/4.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSEmotionKeyboardCell: UICollectionViewCell {
    
    var emoticon:CSKeyboardEmoticons? {
        didSet {
            // 显示emoji表情
            iconBtn.setTitle(emoticon?.emoticonStr ?? "", forState: UIControlState.Normal)
             iconBtn.setImage(
            nil, forState: UIControlState.Normal)
            // 设置图片表情
            if emoticon?.chs != nil {
                iconBtn.setImage(UIImage(contentsOfFile: (emoticon!.pngPath)!), forState: UIControlState.Normal)
            }
            // 设置删除按钮
            if emoticon!.isRemoveButton {
                iconBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(iconBtn)
        iconBtn.backgroundColor = UIColor.whiteColor()
        iconBtn.frame = CGRectInset(bounds, 4, 4)
    }
    private lazy var iconBtn:UIButton = {
        let btn = UIButton()
        btn.userInteractionEnabled = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(30)
        return btn
    }()
}
