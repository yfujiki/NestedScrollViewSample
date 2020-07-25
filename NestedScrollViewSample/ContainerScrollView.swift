//
//  ContainerScrollView.swift
//  NestedScrollViewSample
//
//  Created by Yuichi Fujiki on 25/7/20.
//  Copyright © 2020 yfujiki. All rights reserved.
//

import UIKit

var observersDict: [UIView: [NSObjectProtocol]] = [:]

class ContainerScrollView: UIScrollView {

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let contentView = subviews.first(where: { $0 is ContainerScrollContentView }) else { return }

        var yOffsetCurrentSubview = CGFloat(0)

        for (index, scrollSubview) in contentView.subviews.filter({ $0 is UIScrollView }).enumerated() {
            let scrollView = scrollSubview as! UIScrollView

            let offsetY = contentOffset.y - yOffsetCurrentSubview
            let frameBottomY = offsetY + frame.height

            NSLog("\(index): \(offsetY) - \(frameBottomY)")
            if frameBottomY <= 0 {
                scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0)
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
            } else if offsetY >= scrollView.contentSize.height {
                scrollView.frame = CGRect(x: 0, y: offsetY, width: scrollView.frame.width, height: 0)
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
            } else if offsetY >= 0 {
                // Lower part is visible
                let subViewHeight = min(scrollView.contentSize.height - offsetY, frame.height)
                scrollView.frame = CGRect(x: 0, y: offsetY + yOffsetCurrentSubview, width: scrollView.frame.width, height: subViewHeight)
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
                NSLog("\(index): \(scrollView.frame)")
            } else {
                // Upper part is visible
                let subViewHeight = min(frameBottomY, frame.height)
                scrollView.frame = CGRect(x: 0, y: yOffsetCurrentSubview, width: scrollView.frame.width, height: subViewHeight)
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                NSLog("\(index): \(scrollView.frame)")
            }

            yOffsetCurrentSubview += scrollView.contentSize.height
        }
    }
}

class ContainerScrollContentView: UIView {

}


