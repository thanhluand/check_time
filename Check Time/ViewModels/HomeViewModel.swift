//
//  HomeViewModel.swift
//  GithubUser
//
//  Created by Dang Luan on 2024/08/05.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchData()
}

class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    
    var usersList: [User] = []
    var paging = -1
    var lastSearchContent = ""
    var isFetching = false
    
    var lastIndex: Int {
        get {
            return usersList.count
        }
    }
    
    func refreshData() {
        paging = -1
        usersList = []
        getUser(searchContent: lastSearchContent)
    }
    
    func getUser(searchContent: String) {
        if (lastSearchContent != searchContent) {
            usersList = []
            paging = -1
        }
        if (searchContent.isEmpty) {
            isFetching = true
            APIClient.request(endpoint: UserEndPoint.getUsers(since: lastIndex, perPage: Constants.Common.MaxRequestItem)) { [weak self] (result: Result<[User], AppError>) in
                guard let self = self else { return }
                switch result {
                case .success(let datas):
                    self.usersList.append(contentsOf: datas)
                    isFetching = false
                    delegate?.didFetchData()
                    print("Success: append \(datas.count)")
                case .failure(let error):
                    isFetching = false
                    print("failure: \(error)")
                    // TODO: handle error here
                }
            }
        } else {
            paging += 1
            isFetching = true
            APIClient.request(endpoint: UserEndPoint.searchUsers(keyword: searchContent, page: paging, perPage: Constants.Common.MaxRequestItem)) { [weak self] (result: Result<SearchUser, AppError>) in
                guard let self = self else { return }
                switch result {
                case .success(let datas):
                    self.usersList.append(contentsOf: datas.items)
                    isFetching = false
                    delegate?.didFetchData()
                    print("Success: append \(datas.items.count)")
                case .failure(let error):
                    isFetching = false
                    print("failure: \(error)")
                    // TODO: handle error here
                }
            }
        }
        lastSearchContent = searchContent
    }
}
