//
//  CTExtension+UIColor.swift
//  ChanelProject
//
//  Created by 陈旺 on 2022/10/28.
//  Copyright © 2022 Yang, Xinliang, Connext China. All rights reserved.
//

import SwiftUI
import UIKit

extension UIColor {
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    static func rgbaf(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    /// 初始化:十六进制颜色
    ///
    /// - Parameter hexString: 十六进制颜色字符串(1:有#,2:没有#,3:含有0X)
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var cstr = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if cstr.length < 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
            return
        }
        if cstr.hasPrefix("0X") {
            cstr = cstr.substring(from: 2) as NSString
        }
        if cstr.hasPrefix("#") {
            cstr = cstr.substring(from: 1) as NSString
        }
        if cstr.length != 6 {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
            return
        }
        var range = NSRange()
        range.location = 0
        range.length = 2
        let rStr = cstr.substring(with: range)
        range.location = 2
        let gStr = cstr.substring(with: range)
        range.location = 4
        let bStr = cstr.substring(with: range)
        var r: UInt64 = 0x0
        var g: UInt64 = 0x0
        var b: UInt64 = 0x0
        Scanner(string: rStr).scanHexInt64(&r)
        Scanner(string: gStr).scanHexInt64(&g)
        Scanner(string: bStr).scanHexInt64(&b)
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}

extension Color {
    init(hexString: String) {
        self.init(hexString, bundle: nil)
    }
}

extension Text {
    func textForeGroundColor(hexString: String) -> Text {
        if #available(iOS 17.0, *) {
            return self.foregroundStyle(
                Color(hexString: hexString)
            )
        } else {
            return foregroundColor(
                Color(hexString: hexString)
            )
        }
    }

    func textForeGroundColor(color: Color) -> Text {
        if #available(iOS 17.0, *) {
            return self.foregroundStyle(
                color
            )
        } else {
            return foregroundColor(
                color
            )
        }
    }
}

extension View {
    func viewForeGroundColor(hexString: String) -> some View {
        if #available(iOS 17.0, *) {
            return self.foregroundStyle(
                Color(hexString: hexString)
            )
        } else {
            return foregroundColor(
                Color(hexString: hexString)
            )
        }
    }

    func viewForeGroundColor(color: Color) -> some View {
        if #available(iOS 17.0, *) {
            return self.foregroundStyle(
                color
            )
        } else {
            return foregroundColor(
                color
            )
        }
    }
}
