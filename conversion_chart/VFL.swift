//
//  VFL.swift
//  CWKit
//
//  官方VFL布局
//  封装了部分API，简化布局调用方法
//  Created by 陈旺 on 2022/8/8.
//

import UIKit

extension UIView {
    /// 上下左右对齐
    /// - Parameter targetView: 目标view
    func edgeTo(targetView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: targetView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: targetView.trailingAnchor).isActive = true
    }

    /// 距离底部安全区距离约束
    /// - Parameters:
    ///   - targetView: 目标view
    ///   - constant: 间距
    /// - Returns: layout对象
    @discardableResult
    func bottomToSafeBottom(targetView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            return self.bottomAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.bottomAnchor, constant: constant)
        } else {
            return bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: constant)
        }
    }

    /// 设置顶部安全区间距
    /// - Parameters:
    ///   - targetView: 目标view
    ///   - constant: 间距
    /// - Returns: layout对象
    @discardableResult
    func topToSafeTop(targetView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            return self.topAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.topAnchor, constant: constant)
        } else {
            return topAnchor.constraint(equalTo: targetView.topAnchor, constant: constant)
        }
    }

    func edgeTo(targetView: UIView, inset: UIEdgeInsets) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: inset.left).isActive = true
        bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: inset.bottom).isActive = true
        trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: inset.right).isActive = true
        topAnchor.constraint(equalTo: targetView.topAnchor, constant: inset.top).isActive = true
    }

    /// VFL布局
    /// - Parameters:
    ///   - format: 布局format字符串
    ///   - views: 视图键值对
    ///   - options: 布局可选项
    ///   - metrics: 间距键值对
    /// - Returns: 约束对象数组
    @discardableResult
    func withVFL(_ format: String, views: [String: UIView], options: NSLayoutConstraint.FormatOptions = [], metrics: [String: Any]? = nil) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views)
        addConstraints(constraints)
        return constraints
    }
}

extension NSLayoutConstraint {
    func setIsActive(_ active: Bool = true) -> NSLayoutConstraint {
        isActive = active
        return self
    }

    func setThePriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue: priority)
        return self
    }
}

extension Dictionary where Key == String, Value == UIView {
    func addTo(superView: UIView) {
        for itemView in Array(values) {
            itemView.translatesAutoresizingMaskIntoConstraints = false
            superView.addSubview(itemView)
        }
    }
}

extension UIEdgeInsets {
    static let normalInsets = UIEdgeInsets.init(top: -20, left: -20, bottom: 20, right: 20)
}
