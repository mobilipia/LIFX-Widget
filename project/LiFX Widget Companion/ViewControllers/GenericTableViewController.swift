//
//  GenericTableViewController.swift
//  LiFX Widget
//
//  Created by Maxime de Chalendar on 9/5/14.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation

class GenericTableViewController: UITableViewController,
DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    
    // MARK: Properties
    var emptyImage: UIImage?
    var emptyTitle: String?
    var emptyDescription: String?
    var emptyButtonTitle: String?
    var tintColor: UIColor?
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureEmptyDataSet()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tintColor = tintColor {
            configureNavigationBarColor(tintColor, buttonsColor: UIColor.whiteColor())
        }
    }
    
    
    // MARK: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return emptyImage
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if let emptyTitle = emptyTitle {
            return attributedStringWithTitle(emptyTitle, size: 18, color: UIColor.blackColor())
        } else {
            return nil
        }
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if let emptyDescription = emptyDescription {
            return attributedStringWithTitle(emptyDescription, size: 12, color: tintColor ?? UIColor.lightGrayColor())
        } else {
            return nil
        }
    }

    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        if let emptyButtonTitle = emptyButtonTitle {
            return attributedStringWithTitle(emptyButtonTitle, size: 12, color: tintColor ?? UIColor.lightGrayColor())
        } else {
            return nil
        }
    }
    
    
    // MARK: Public methods
    func configureNavigationBarColor(navigationBarColor: UIColor, buttonsColor: UIColor) {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = buttonsColor
            navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: buttonsColor ]
            navigationBar.barTintColor = navigationBarColor
        }
    }
    
    
    // MARK: Convenience methods
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 245/CGFloat(255), green: 245/CGFloat(255), blue: 245/CGFloat(255), alpha: 1)
    }
    
    func configureEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    func attributedStringWithTitle(title: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(12),
            NSForegroundColorAttributeName: color
        ])
    }
}