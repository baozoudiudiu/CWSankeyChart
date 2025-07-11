//
//  ViewController.swift
//  conversion_chart
//
//  Created by 陈旺 on 2025/7/10.
//
import UIKit

class ViewController: UIViewController {
    
    lazy var sankeyChartView: CWSankeyChartView = {
        let view = CWSankeyChartView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let map: [String: UIView] = [
            "conversionChartView": sankeyChartView
        ]
        map.addTo(superView: self.view)
        self.view.withVFL("H:|-20-[conversionChartView]-10-|", views: map)
        self.view.withVFL("V:|-100-[conversionChartView(300)]", views: map)
    }
    
    @IBAction func onClickStartDrawChartAction(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            sender.isUserInteractionEnabled = true
        })
        self.sankeyChartView.drawChart(columnDatas: [
            [
                .init(id: "0", title: "我(开发)", value: 20.0, color: "#E4CFA8".hexColor),
                .init(id: "1", title: "其他人(开发)", value: 8.0, color: "#776161".hexColor)
            ],
            [
                .init(id: "2", title: "我(转化)", value: 18.0, color: "#E4CFA8".hexColor),
                .init(id: "3", title: "其他人(转化)", value: 6.0, color: "#776161".hexColor),
                .init(id: "4", title: "无人转化", value: 4.0, color: "#B1B1AF".hexColor)
            ],
            [
                .init(id: "5", title: "类型A: 我开发我转化", value: 10.0, color: "#E4CFA8".hexColor),
                .init(id: "6", title: "类型B: 我开发别人转化", value: 6.0, color: "#E4CFA8".hexColor),
                .init(id: "7", title: "类型C: 别人开发我转化", value: 8.0, color: "#E4CFA8".hexColor),
                .init(id: "8", title: "类型D: 我开发无人转化", value: 4.0, color: "#E4CFA8".hexColor)
            ],
        ], links: [
            .init(id: "0", fromId: "0", value: 6.0, toId: "3", color: "#E4CFA8".hexColor),
            .init(id: "1", fromId: "0", value: 4.0, toId: "4", color: "#B1B1AF".hexColor),
            .init(id: "2", fromId: "0", value: 10.0, toId: "2", color: "#E4CFA8".hexColor),
            .init(id: "3", fromId: "1", value: 8.0, toId: "2", color: "#776161".hexColor),
            .init(id: "4", fromId: "2", value: 10.0, toId: "5", color: "#E4CFA8".hexColor),
            .init(id: "5", fromId: "2", value: 8.0, toId: "7", color: "#E4CFA8".hexColor),
            .init(id: "6", fromId: "3", value: 6.0, toId: "6", color: "#E4CFA8".hexColor),
            .init(id: "7", fromId: "4", value: 4.0, toId: "8", color: "#B1B1AF".hexColor),
        ])
    }
}

