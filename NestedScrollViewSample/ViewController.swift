//
//  ViewController.swift
//  NestedScrollViewSample
//
//  Created by Yuichi Fujiki on 25/7/20.
//  Copyright © 2020 yfujiki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!

    @IBOutlet var heightDimensionConstraint: NSLayoutConstraint!

    static let numberOfRows = 200

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
//        setupKVO()
    }

    private func setupViews() {
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        tableView1.dataSource = self
        tableView2.dataSource = self

        heightDimensionConstraint.constant = CGFloat(Self.numberOfRows * 2 * 44)
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Self.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!

        cell.textLabel?.text = "\(indexPath)"

        if tableView == tableView1 {
            cell.contentView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        } else {
            cell.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
        return cell
    }
}
