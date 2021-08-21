//
//  FollowsViewController.swift
//  Genies
//
//  Created by Yegor on 03.08.2021.
//

import UIKit

class FollowsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "FollowsViewCell", bundle: nil), forCellReuseIdentifier: FollowsViewCell.cellIdentifier)
    }
    
    @IBAction func searchDidTap(_ sender: Any) {
        
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
}


extension FollowsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // with user id
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        guard let profilePage = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        profilePage.isOtherUser = true
        navigationController?.pushViewController(profilePage, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.vibro(.light)
    }
}

extension FollowsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowsViewCell", for: indexPath) as? FollowsViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.default

//        cell.bind(viewModel: items[indexPath.row])
                
        return cell
    }
}
