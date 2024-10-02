//
//  HomeViewController.swift
//  GithubUser
//
//  Created by Dang Luan on 2024/08/04.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var timer:Timer?
    
    private var searchController: UISearchController!
    let refreshControl = UIRefreshControl()
    
    let userModel = HomeViewModel()
    var searchContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 95
        tableView.rowHeight = UITableView.automaticDimension
        userModel.delegate = self
        userModel.getUser(searchContent: searchContent)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func refresh() {
        userModel.refreshData()
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController else { return }
        let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell
        vc.userName = userModel.usersList[indexPath.row].login
        vc.avatarImg = cell?.avatar.image ?? UIImage()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModel.usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let data = userModel.usersList[indexPath.row]
        cell.setup(user: data)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row >= userModel.lastIndex - 5 && !userModel.isFetching) {
            userModel.getUser(searchContent: searchContent)
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchContent = searchController.searchBar.text ?? ""
        if (searchContent == userModel.lastSearchContent) {
            return
        }
        print(searchContent)
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.searchUser), userInfo: nil, repeats: false)
    }
    
    @objc func searchUser() {
        userModel.getUser(searchContent: searchContent)
    }
    
}

extension HomeViewController: HomeViewModelDelegate {
    func didFetchData() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}
