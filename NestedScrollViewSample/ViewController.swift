//
//  ViewController.swift
//  NestedScrollViewSample
//
//  Created by Yuichi Fujiki on 25/7/20.
//  Copyright © 2020 yfujiki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static let numberOfRows = 60

    @IBOutlet var scrollView: ContainerScrollView!

    var tableViews: [UITableView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        (0..<4).forEach { (_) in
            let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0))
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.dataSource = self
            tableViews.append(tableView)
            scrollView.contentView.addSubview(tableView)
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Self.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!

        cell.textLabel?.text = "\(indexPath)"

        let index = tableViews.firstIndex(of: tableView)
        let color: UIColor
        switch index {
        case 0:
            color = .yellow
        case 1:
            color = .red
        case 2:
            color = .blue
        case 3:
            color = .green
        default:
            color = .systemPink
        }
        cell.contentView.backgroundColor = color.withAlphaComponent(0.5)

        return cell
    }
}
