//
//  CWConversionChartView.swift
//  conversion_chart
//
//  Created by 陈旺 on 2025/7/10.
//

import UIKit

/// 转化图
class CWSankeyChartView: UIView {
    // MARK: - 属性
    /// 柱子宽度
    var columnWidth: CGFloat = 10.0
    
    /// 柱子的纵向间距
    var columnVPadding: CGFloat = 5.0
    
    /// 最右边一根柱子文字的最大宽度
    var farRightTextMaxWidth: CGFloat = 90.0
    
    /// 图表宽度
    private var chartWidth: CGFloat {
        return self.bounds.size.width
    }
    
    /// 图表高度
    private var chartHeight: CGFloat {
        return self.bounds.size.height
    }
    
    /// 一共有几列柱子
    private var columnCount: Int {
        return self.columnDatasArr.count
    }
    
    /// 每列柱子之间的间距
    private var columnHMargin: CGFloat {
        let count = CGFloat(self.columnCount)
        let width = self.chartWidth - self.columnWidth * count - self.farRightTextMaxWidth
        return width / (count - 1.0)
    }
    
    /// 柱子视图数组
    private var columnViewArr: [CWConversionColumnView] = []
    
    /// 弧线layer数组
    private var lineLayerArr: [CAShapeLayer] = []
    
    /// 文本数组
    private var labelArr: [UILabel] = []
    
    /// 柱子数据模型二维数组
    private var columnDatasArr: [[CWSankeyChartModel]] = []
    
    /// 转化率数据模型数组
    private var columnLinks: [CWSankeyChartLinkModel] = []
    
    /// 动画视图
    private(set) lazy var animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Open API
    /// 开始绘制表格
    func drawChart(columnDatas: [[CWSankeyChartModel]],
                   links: [CWSankeyChartLinkModel] = []) {
        self.columnDatasArr = columnDatas
        self.columnLinks = links
        self.removeAll()
        self.drawColumnView()
        self.drawBezierPath()
        
        // 给一个简易的动画
        if self.animationView.superview == nil {
            self.animationView.frame = self.bounds
            self.animationView.layer.zPosition = 100
            self.addSubview(self.animationView)
        }
        self.animationView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveLinear) { [weak self] in
            guard let `self` = self else { return }
            self.animationView.transform = CGAffineTransformMakeTranslation(self.chartWidth, 0)
        }
    }
    
    // MARK: - Logic Helper
    /// 绘制三阶曲线
    /// - Parameters:
    ///   - path: 贝塞尔曲线对象
    ///   - startPoint: 曲线起点
    ///   - endPoint: 曲线终点
    private func addCurve(path: UIBezierPath,
                          from startPoint: CGPoint,
                          to endPoint: CGPoint) {
        let maxX = max(startPoint.x, endPoint.x)
        let minX = min(startPoint.x, endPoint.x)
        let maxY = max(startPoint.y, endPoint.y)
        let minY = min(startPoint.y, endPoint.y)
        let midPoint = CGPoint(x: (maxX - minX) / 2 + minX,
                               y: (maxY - minY) / 2 + minY)
        let controlPoint1 = CGPoint(x: midPoint.x, y: startPoint.y)
        let controlPoint2 = CGPoint(x: midPoint.x, y: endPoint.y)
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }
    
    /// 更新转化率数据模型
    /// - Parameter linkModel: 数据模型
    private func updateLink(_ linkModel: CWSankeyChartLinkModel) {
        guard let index = self.columnLinks.firstIndex(where: { link in
            return link.id == linkModel.id
        }) else {
            return
        }
        self.columnLinks[index] = linkModel
    }
    
    /// 转化率数据模型换算成弧度数据
    private func initLinkPointData() {
        for (_, columnView) in self.columnViewArr.enumerated() {
            guard let columnModel = columnView.columnModel else {
                continue
            }
            let section = columnView.columnIndex
            let fromlinks = self.columnLinks.filter { $0.fromId == columnModel.id }
            var fromX = (columnWidth + columnHMargin) * CGFloat(section) + columnWidth
            var fromY = columnView.frame.minY
            for (_, var linkModel) in fromlinks.enumerated() {
                let fromOrigin = CGPoint.init(x: fromX, y: fromY)
                let toOrigin  = CGPoint.init(x: fromX, y: fromY + columnView.frame.height * linkModel.value / columnModel.value)
                fromY = toOrigin.y
                linkModel.fromPoint = (fromOrigin, toOrigin)
                self.updateLink(linkModel)
            }
            
            let toLinks = self.columnLinks.filter { $0.toId == columnModel.id }
            fromX = (columnWidth + columnHMargin) * CGFloat(section)
            fromY = columnView.frame.minY
            for (_, var linkModel) in toLinks.enumerated() {
                let fromOrigin = CGPoint.init(x: fromX, y: fromY)
                let toOrigin = CGPoint.init(x: fromX, y: fromY + columnView.frame.height * linkModel.value / columnModel.value)
                fromY = toOrigin.y
                linkModel.toPoint = (fromOrigin, toOrigin)
                self.updateLink(linkModel)
            }
        }
    }
    
    /// 移除所有视图
    private func removeAll() {
        self.columnViewArr.forEach { $0.removeFromSuperview() }
        self.lineLayerArr.forEach { $0.removeFromSuperlayer() }
        self.labelArr.forEach { $0.removeFromSuperview() }
        self.columnViewArr.removeAll()
        self.lineLayerArr.removeAll()
        self.labelArr.removeAll()
        self.animationView.transform = CGAffineTransform.identity
    }
    
    // MARK: - UI
    /// 开始绘制柱子
    private func drawColumnView() {
        // 开始绘制每列的柱子
        for (index, columns) in self.columnDatasArr.enumerated() {
            let startX = CGFloat(index) * (columnWidth + columnHMargin)
            // 当前列柱子的总值
            let totalValue = columns.reduce(0) { partialResult, model in
                return partialResult + model.value
            }
            // 子柱子之间的纵向间距总和
            let totalMargin = self.columnVPadding * CGFloat(columns.count - 1)
            // 计算出剩余的高度就是子柱子的高度总和
            let totalHeight = chartHeight - totalMargin
            // 开始绘制子柱子
            var startY: CGFloat = 0
            for (subIndex, columnModel) in columns.enumerated() {
                // 子柱子高度
                let height = totalHeight * columnModel.value / totalValue
                let origin = CGPoint.init(x: startX, y: startY)
                let size = CGSize.init(width: self.columnWidth, height: height)
                let columnView = CWConversionColumnView()
                columnView.columnModel = columnModel
                columnView.columnIndex = index
                columnView.itemIndex = subIndex
                columnView.frame = CGRect.init(origin: origin, size: size)
                columnView.backgroundColor = columnModel.color
                self.addSubview(columnView)
                self.columnViewArr.append(columnView)
                startY = startY + height + self.columnVPadding
                
                // 设置文本
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 8.0)
                label.textColor = .black
                label.numberOfLines = 0
                label.textAlignment = .left
                label.text = "\(columnModel.title)\n\(columnModel.value)"
                label.translatesAutoresizingMaskIntoConstraints = false
                label.layer.zPosition = 99
                self.addSubview(label)
                self.labelArr.append(label)
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: columnView.trailingAnchor, constant: 2),
                    label.centerYAnchor.constraint(equalTo: columnView.centerYAnchor),
                    label.widthAnchor.constraint(lessThanOrEqualToConstant: (CGFloat(index) == CGFloat(columnCount) - 1.0) ? self.farRightTextMaxWidth : columnHMargin)
                ])
            }
        }
    }
    
    /// 开始绘制贝塞尔曲线
    private func drawBezierPath() {
        // 初始化数据
        self.initLinkPointData()
        // 开始绘制
        for link in self.columnLinks {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: link.fromPoint.0)
            self.addCurve(path: bezierPath,
                          from: link.fromPoint.0,
                          to: link.toPoint.0)
            bezierPath.addLine(to: link.toPoint.1)
            self.addCurve(path: bezierPath,
                          from: link.toPoint.1,
                          to: link.fromPoint.1)
            bezierPath.addLine(to: link.fromPoint.0)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = self.bounds
            shapeLayer.path = bezierPath.cgPath
            shapeLayer.fillColor = link.color.cgColor
            shapeLayer.opacity = 0.3
            shapeLayer.lineWidth = 1.0
            self.layer.addSublayer(shapeLayer)
            self.lineLayerArr.append(shapeLayer)
        }
    }
}
