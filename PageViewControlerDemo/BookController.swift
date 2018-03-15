//
//  BookController.swift
//  PageViewControlerDemo
//
//  Created by min-mac on 16/3/12.
//  Copyright © 2016年 EgeTart. All rights reserved.
//

import UIKit

class BookController: UIViewController {
    
    @IBOutlet var bookTableView: UITableView!
    
    var bookResults: BookResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookTableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
        bookTableView.dataSource = self
        bookTableView.delegate = self
        
        GetDataFromDouBan.getData(dataURL: "https://api.douban.com/v2/book/search", type: "books", keyword: "swift") { (data) -> Void in
            self.bookResults = BookResults(dicts: data)
            self.bookTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //发送一个名字为currentPageChanged，附带object的值代表当前页面的索引
        NotificationCenter.default.post(name: Notification.Name(rawValue: "currentPageChanged"), object: 2)
    }
    
}

extension BookController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = bookResults {
            return result.books.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let music = bookResults!.books[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath) as! CommonCell
        cell.coverImageView.sd_setImage(with: URL(string: music.imageURL))
        cell.titleLabel.text = music.title
        
        return cell
    }
}

extension BookController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
