//
//  CSEmotionKeyboardController.swift
//  EmotionKeyboard
//
//  Created by 石冬冬 on 16/12/3.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSEmotionKeyboardController: UIViewController {

    var packages:[CSEmotionKeyboardPackage] = CSEmotionKeyboardPackage.loadEmotionPackages()
    
    // 回调闭包
    var emoticonCallback:(emoticon:CSKeyboardEmoticons)->()
    
    init(callback:(emoticon:CSKeyboardEmoticons)->()) {
        
        self.emoticonCallback = callback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        // 布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let dict = ["collectionView":collectionView,"toolBar":toolBar]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics:nil , views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-[toolBar(49)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(cons)
    }
    
    @objc private func itemClick(item:UIBarButtonItem) {
        // 滚动到指定的indexpath
        print(item.tag)
        let indexpath = NSIndexPath(forItem: 0, inSection: item.tag)
        collectionView.scrollToItemAtIndexPath(indexpath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }

    // MARK: -懒加载
    private lazy var collectionView:UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: CSEmotionKeyboardLayout())
        clv.backgroundColor = UIColor.greenColor()
        clv.dataSource = self
        clv.delegate = self
        clv.registerClass(CSEmotionKeyboardCell.self, forCellWithReuseIdentifier: "keyboardCell")
        return clv 
    }()
    
    private lazy var toolBar:UIToolbar = {
        let tb = UIToolbar()
        tb.tintColor = UIColor.lightGrayColor()
        var items = [UIBarButtonItem]()
        var index = 0
        for title in ["最近","默认","Emoji","浪小花"] {
            // 创建item
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("itemClick:"))
            item.tag = index++
            // 创建间隙
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            items.append(flexibleItem)
            items.append(item)
            items.append(flexibleItem)
        }
        // 将item添加到toolbar上
        tb.items = items
        return tb
    }()
}

extension CSEmotionKeyboardController:UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("keyboardCell", forIndexPath: indexPath) as! CSEmotionKeyboardCell
        let package = packages[indexPath.section]
        cell.emoticon = package.emoticons![indexPath.item]
        return cell
    }
}

extension CSEmotionKeyboardController:UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let package = packages[indexPath.section]
        let emoticon = package.emoticons![indexPath.item]
        // 每使用一次加1
        emoticon.count += 1
        // 判断是否为删除按钮
        if !emoticon.isRemoveButton {
            // 将当前点击的表情添加到最近组
            packages[0].addFavoriteEmoticon(emoticon)
        }
        
        //
        emoticonCallback(emoticon: emoticon)
    }
}
class CSEmotionKeyboardLayout : UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        let width = UIScreen.mainScreen().bounds.width/7
        let height = collectionView!.bounds.height/3
        itemSize = CGSizeMake(width, height)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false

    }
}