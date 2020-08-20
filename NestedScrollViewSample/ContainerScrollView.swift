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

    var currentPageIndex = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    private func setupViews() {
        _ = contentView
    }

    private var contentViewHeightConstraint: NSLayoutConstraint!

    private(set) lazy var contentView: ContainerScrollContentView = {
        let contentView = ContainerScrollContentView()

        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])

        self.contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 0)
        self.contentViewHeightConstraint.isActive = true

        return contentView
    }()

    func didAddContentSubview(_ subview: UIView) {
        if let scrollView = subview as? UIScrollView {
            scrollView.isScrollEnabled = false
        }

        if let pageContentView = contentView.subviews.first(where: {
            let className = NSStringFromClass(type(of: $0))
            return className == "_UIPageViewControllerContentView"
        }) {

            if let queueingScrollView = pageContentView.subviews.first(where: {
                let className = NSStringFromClass(type(of: $0))
                return className == "_UIQueuingScrollView"
            }) {

                for pageView in queueingScrollView.subviews {
                    if let scrollView = pageView.subviews.first?.subviews.first as? UIScrollView {
                        scrollView.isScrollEnabled = false
                    }
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let contentView = subviews.first(where: { $0 is ContainerScrollContentView }) else { return }

        var yOffsetCurrentSubview = CGFloat(0)

        for scrollSubview in contentView.subviews.filter({ $0 is UIScrollView }) {
            let scrollView = scrollSubview as! UIScrollView
            let tag = scrollView.tag

            let offsetY = contentOffset.y - yOffsetCurrentSubview
            let frameBottomY = offsetY + frame.height

            NSLog("\(tag): \(offsetY) - \(frameBottomY)")
            if frameBottomY <= 0 {
                // Lower than the window
                scrollView.frame = CGRect(x: 0, y: yOffsetCurrentSubview, width: scrollView.frame.width, height: 0)
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
            } else if offsetY >= scrollView.contentSize.height {
                // Higher than the window
                scrollView.frame = CGRect(x: 0, y: scrollView.contentSize.height + yOffsetCurrentSubview, width: scrollView.frame.width, height: 0)
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
            } else if offsetY >= 0 {
                // Lower part is visible
                let subViewHeight = min(scrollView.contentSize.height - offsetY, frame.height)
                scrollView.frame = CGRect(x: 0, y: offsetY + yOffsetCurrentSubview, width: scrollView.frame.width, height: subViewHeight)
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
                NSLog("\(tag): \(scrollView.frame)")
            } else {
                // Upper part is visible
                let subViewHeight = min(frameBottomY, frame.height)
                scrollView.frame = CGRect(x: 0, y: yOffsetCurrentSubview, width: scrollView.frame.width, height: subViewHeight)
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                NSLog("\(tag): \(scrollView.frame)")
            }

            yOffsetCurrentSubview += scrollView.contentSize.height
        }

        if let pageContentView = contentView.subviews.first(where: {
            let className = NSStringFromClass(type(of: $0))
            return className == "_UIPageViewControllerContentView"
        }) {
            var pageViewContentHeight = CGFloat(0)
            var pageViewHeight = CGFloat(0)
            var pageViewOffset = CGFloat(0)

            if let queueingScrollView = pageContentView.subviews.first(where: {
                let className = NSStringFromClass(type(of: $0))
                return className == "_UIQueuingScrollView"
            }) {
                for pageView in queueingScrollView.subviews {
                    if let scrollView = pageView.subviews.first?.subviews.first as? UIScrollView, scrollView.tag == currentPageIndex {
                        let tag = scrollView.tag

                        let offsetY = contentOffset.y - yOffsetCurrentSubview
                        let frameBottomY = offsetY + frame.height

                        NSLog("P \(tag): \(offsetY) - \(frameBottomY)")
                        if frameBottomY <= 0 {
                            // Lower than the window
                            scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 0)
                            scrollView.contentOffset = CGPoint(x: 0, y: 0)
                        } else if offsetY >= scrollView.contentSize.height {
                            // Higher than the window
                            scrollView.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.frame.width, height: 0)
                            scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
                        } else if offsetY >= 0 {
                            // Lower part is visible
                            let subViewHeight = min(scrollView.contentSize.height - offsetY, frame.height)
                            scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: subViewHeight)
                            scrollView.contentOffset = CGPoint(x: 0, y: offsetY)
                            NSLog("P \(tag): \(scrollView.frame)")
                        } else {
                            // Upper part is visible
                            let subViewHeight = min(frameBottomY, frame.height)
                            scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: subViewHeight)
                            scrollView.contentOffset = CGPoint(x: 0, y: 0)
                            NSLog("P \(tag): \(scrollView.frame)")
                        }

                        pageViewContentHeight = max(pageViewContentHeight, scrollView.contentSize.height)

                        pageViewHeight = max(pageViewHeight, scrollView.bounds.height)

                        pageViewOffset = yOffsetCurrentSubview

                        if offsetY > 0 {
                            pageViewOffset += offsetY
                        }
                    }
                }
            }
            pageContentView.frame = CGRect(x: 0, y: pageViewOffset, width: pageContentView.frame.width, height: pageViewHeight)
            yOffsetCurrentSubview += pageViewContentHeight
        }

        contentSize = CGSize(width: self.bounds.width, height: yOffsetCurrentSubview)
        contentViewHeightConstraint.constant = yOffsetCurrentSubview
    }
}

class ContainerScrollContentView: UIView {
    override func didAddSubview(_ subview: UIView) {
        guard let superScrollView = superview as? ContainerScrollView else { return }
        superScrollView.didAddContentSubview(subview)
    }
}
