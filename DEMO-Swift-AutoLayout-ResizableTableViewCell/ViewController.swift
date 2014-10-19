//
//  ViewController.swift
//  DEMO-Swift-AutoLayout-ResizableTableViewCell
//
//  Created by grachro on 2014/10/19.
//  Copyright (c) 2014年 grachro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    var tmpCalculatHeightCell:MyTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Auto Layout
        Layout.regist(tableView,superview: self.view)
            .coverSuperView()
        
        self.tableView.registerClass(MyTableViewCell.self, forCellReuseIdentifier: "MyTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension ViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("MyTableViewCell", forIndexPath: indexPath) as MyTableViewCell
        
        let containtHeight = CGFloat(indexPath.row + 1) * 5
        cell.setHeight(containtHeight)
        
        return cell
    }
    
}

extension ViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let containtHeight = CGFloat(indexPath.row + 1) * 5
        
        if self.tmpCalculatHeightCell == nil {
            self.tmpCalculatHeightCell = self.tableView.dequeueReusableCellWithIdentifier("MyTableViewCell") as? MyTableViewCell
        }
        
        if let cell = self.tmpCalculatHeightCell as MyTableViewCell! {
            cell.setHeight(containtHeight)
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell.totalCellHeight
        }
        
        return 0
    }
    
}

class MyTableViewCell : UITableViewCell {
    
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var baseViewLayout:Layout?
    var resizableViewLayout:Layout?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.redColor()
        
        //Auto Layout
        self.baseViewLayout = Layout.registUIView(superview: self.contentView)
            .widthIsSame(self.contentView)
        
        //Auto Layout
        self.resizableViewLayout = Layout.registUIView(superview: self.baseViewLayout!.view)
            .top(10).fromSuperviewTop()
            .bottom(10).fromSuperviewBottom()
            .width(0).lastConstraint(&widthConstraint)
            .height(0).lastConstraint(&heightConstraint)
            .horizontalCenterInSuperview()
            .backgroundColor(UIColor.yellowColor())
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeight(height:CGFloat) {
        self.widthConstraint?.constant = height
        self.heightConstraint?.constant = height
    }
    
    var totalCellHeight:CGFloat {
        return baseViewLayout!.view.bounds.height
    }
}