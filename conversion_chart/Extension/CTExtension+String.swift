//
//  CTExtension+String.swift
//  ChanelProject
//
//  Created by 陈旺 on 2022/10/8.
//  Copyright © 2022 Yang, Xinliang, Connext China. All rights reserved.
//

import UIKit

extension String {
    /// 转16进制颜色
    var hexColor: UIColor {
        UIColor(hexString: self)
    }
}
