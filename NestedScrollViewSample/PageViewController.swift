//
//  PageViewController.swift
//  NestedScrollViewSample
//
//  Created by Yuichi Fujiki on 20/8/20.
//  Copyright © 2020 yfujiki. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var vcs: [TableViewController] = []
    var pageTransitionedTo: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = .white
        
        vcs = (0..<4).map { (i) -> TableViewController in
            return TableViewController(index: i)
        }

        self.dataSource = self
        self.delegate = self

        self.setViewControllers([vcs[0]], direction: .forward, animated: false, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? TableViewController else { return nil }

        let beforeIndex = vc.index - 1

        guard beforeIndex >= 0 else { return nil }

        return vcs[beforeIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? TableViewController else { return nil }

        let afterIndex = vc.index + 1

        guard afterIndex < vcs.count else { return nil }

        return vcs[afterIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?.first as? TableViewController else { return }

        let viewControllerIndex = vc.index
        NSLog("Page transitions to \(viewControllerIndex)")
        pageTransitionedTo?(viewControllerIndex)
    }
}
