//
//  CWSankeyChartModel.swift
//  conversion_chart
//
//  Created by 陈旺 on 2025/7/11.
//

import UIKit

struct CWSankeyChartModel {
    
    var id: String = ""
    
    var title: String = ""
    
    var value: CGFloat = 0.0
    
    var color: UIColor = .black
    
    init(id: String,
         title: String,
         value: CGFloat,
         color: UIColor) {
        self.id = id
        self.title = title
        self.value = value
        self.color = color
    }
}

struct CWSankeyChartLinkModel {
    
    var id: String
    
    var fromId: String
    
    var value: CGFloat
    
    var toId: String
    
    var color: UIColor
    
    var fromPoint: (CGPoint, CGPoint) = (.zero, .zero)
    
    var toPoint: (CGPoint, CGPoint) = (.zero, .zero)
    
    init(id: String,
         fromId: String,
         value: CGFloat,
         toId: String,
         color: UIColor) {
        self.id = id
        self.fromId = fromId
        self.value = value
        self.toId = toId
        self.color = color
    }
}
