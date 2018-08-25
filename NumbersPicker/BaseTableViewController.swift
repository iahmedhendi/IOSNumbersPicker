//
//  BaseTableViewController.swift
//  NumbersPicker
//
//  Created by Hendi on 8/25/18.
//  Copyright © 2018 Hendi. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController<T:TableBaseCell<U>, U>: UITableViewController {
    
    let cellId = "cellId"
    
    var items = [U]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(T.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableBaseCell<U>
        cell.item = self.items[indexPath.row]
        return cell
    }
    
    
    
}
class TableBaseCell<U>: UITableViewCell {
    var item: U!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        
    }
    
    func setupViews() {
        
    }
    
    
    
}
