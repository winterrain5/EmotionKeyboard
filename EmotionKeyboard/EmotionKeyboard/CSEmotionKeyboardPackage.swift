//
//  CSEmotionKeyboardPackage.swift
//  EmotionKeyboard
//
//  Created by 石冬冬 on 16/12/4.
//  Copyright © 2016年 sdd. All rights reserved.
//

import UIKit

class CSEmotionKeyboardPackage: NSObject {
    // 当前组的名称
    var group_name_cn:String?
    // 当前组对应的文件夹的名称
    var id: String?
    // 当前组的所有表情
    var emoticons:[CSKeyboardEmoticons]?
    
    init(id:String) {
        self.id = id
    }
    
    // 加载所有组的数据
    class func loadEmotionPackages() -> [CSEmotionKeyboardPackage] {
        // 手动添加最近组
        var models = [CSEmotionKeyboardPackage]()
        let package = CSEmotionKeyboardPackage(id:"")
        package.appendEmptyEmoticons()
        models.append(package)
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        let dict = NSDictionary(contentsOfFile: path!)
         // 取出所有组的表情
        let array = dict!["packages"] as! [[String:AnyObject]]
        for packageDict in array {
            // 创建当前组模型
            let package = CSEmotionKeyboardPackage(id: packageDict["id"] as! String)
            // 加载当前组所有的表情数据
            package.loadCurrentEmoticons()
            // 补全一组数据，保证当前组能被21整除
            package.appendEmptyEmoticons()
            models.append(package)
        }
        return models
    }
    
    // 加载当前组所有的表情
    private func loadCurrentEmoticons() {
        
        // 手动添加最近组
        var model = [CSEmotionKeyboardPackage]()
        let package = CSEmotionKeyboardPackage(id:"")
        package.appendEmptyEmoticons()
        model.append(package)
        
        // 1、 拼接当前组info.plist的路径
        let path = NSBundle.mainBundle().pathForResource(self.id, ofType: nil, inDirectory: "Emoticons.bundle")
        let filePath = (path! as NSString).stringByAppendingPathComponent("content.plist")
        
        // 根据路径加载info.plist文件
        let dict = NSDictionary(contentsOfFile: filePath)
        
        group_name_cn = dict!["group_name_cn"] as? String
        
        // 取出当前组所有表情
        let array = dict!["emoticons"] as! [[String:AnyObject]]
        // 遍历数组，取出每一个表情
        var models = [CSKeyboardEmoticons]()
        var index = 0
        for emoticonsDict in array {
            
            if index == 20 {
                let emoticon = CSKeyboardEmoticons(isRemoveButton: true)
                models.append(emoticon)
                index = 0
                continue
            }
           let emoticon = CSKeyboardEmoticons(dict: emoticonsDict,id: self.id!)
            index++
            models.append(emoticon)
        }
        emoticons = models
    }
    
    private func appendEmptyEmoticons() {
        
        // 判断是否为最近组
        if emoticons == nil {
            emoticons = [CSKeyboardEmoticons]()
        }
        let  number = emoticons!.count % 21
        // 补全
        for _ in number..<20 {
            let emoticon = CSKeyboardEmoticons(isRemoveButton: false)
            emoticons?.append(emoticon)
        }
        // 补全删除按钮
        let emoticon = CSKeyboardEmoticons(isRemoveButton: true)
        emoticons?.append(emoticon)
    }
    
    // 添加最近表情
    func addFavoriteEmoticon(emoticon: CSKeyboardEmoticons) {
        emoticons?.removeLast()
        
        // 判断当前表情是否已经添加过
        if !emoticons!.contains(emoticon) {
            
            // 添加
            emoticons?.removeLast()
            emoticons?.append(emoticon)
            
        }
        
        // 排序
        emoticons = emoticons?.sort({ (e1, e2) -> Bool in
            return e1.count > e2.count
        })
        
        // 再添加一个删除按钮
        emoticons?.append(CSKeyboardEmoticons(isRemoveButton: true))
    }
}


class CSKeyboardEmoticons:NSObject {
    // 当前组对应的文件夹的名称
    var id: String?
    // 表情对应的中文字符
    var chs:String?
    // 表情对应的图片
    var png:String? {
        didSet {
            // 1、 拼接当前组info.plist的路径
            let path = NSBundle.mainBundle().pathForResource(self.id, ofType: nil, inDirectory: "Emoticons.bundle")
            pngPath = (path! as NSString).stringByAppendingPathComponent(png ?? "")
        }
    }
    // 当前表情对应的绝对路径
    var pngPath:String?
    // Emoji表情对应的字符串
    var code:String? {
        didSet {
            // 创建一个扫描器
            let scanner = NSScanner(string:code!)
            // 从字符串中扫描出对应的16进制数
            var result:UInt32 = 0
            scanner.scanHexInt(&result)
            // 根据扫描出的16进制数创建一个字符串
            emoticonStr = "\(Character(UnicodeScalar(result)))"
        }
    }
    var emoticonStr:String?
    init(dict:[String:AnyObject],id: String) {
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
    }
    // 记录当前表情是否是删除按钮
    var isRemoveButton: Bool = false
    // 当前表情的使用次数
    var count:Int = 0
    init(isRemoveButton:Bool) {
        self.isRemoveButton = isRemoveButton
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}