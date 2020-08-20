//
//  TableViewController.swift
//  NestedScrollViewSample
//
//  Created by Yuichi Fujiki on 20/8/20.
//  Copyright © 2020 yfujiki. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    static let numberOfRows = 200

    let index: Int

    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Self.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!

        cell.textLabel?.text = "\(indexPath)"

        let color: UIColor
        switch index {
        case 3:
            color = .yellow
        case 2:
            color = .red
        case 1:
            color = .blue
        case 0:
            color = .green
        default:
            color = .white
        }
        cell.contentView.backgroundColor = color.withAlphaComponent(0.5)

        return cell
    }
}
