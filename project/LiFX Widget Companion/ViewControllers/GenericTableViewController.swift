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

    var allowsEdition: Bool { return false }
    var originalRightBarButtonItem: UIBarButtonItem?
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureEmptyDataSet()
        if (allowsEdition) {
            addLongPressToReorder()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tintColor = tintColor {
            configureNavigationBarColor(tintColor, buttonsColor: UIColor.whiteColor())
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(tableView, shouldDisplayCustomTitleHeaderViewForSection: section) == false {
            return 0
        }
        
        return 24
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableView(tableView, shouldDisplayCustomTitleHeaderViewForSection: section) == false {
            return nil
        }
        
        var titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = self.tableView(tableView, customTitleForHeaderInSection: section)
        titleLabel.font = UIFont.systemFontOfSize(14)
        
        var headerView = UIView()
        headerView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        headerView.addSubview(titleLabel)

        let views: [NSObject: AnyObject] = ["titleLabel": titleLabel]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]|", options: .allZeros, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[titleLabel]|", options: .AlignAllCenterY, metrics: nil, views: views)
        let constaints = hConstraints + vConstraints
        headerView.addConstraints(constaints)

        return headerView
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return allowsEdition
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return allowsEdition
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if allowsEdition {
            if tableView.editing {
                return .None
            } else {
                return .Delete
            }
        } else {
            return .None
        }
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
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
    
    func emptyDataSetWillAppear(scrollView: UIScrollView!) {
        tableView.tableFooterView?.hidden = true
    }
    
    func emptyDataSetWillDisappear(scrollView: UIScrollView!) {
        tableView.tableFooterView?.hidden = false
    }
    
    func offsetForEmptyDataSet(scrollView: UIScrollView!) -> CGPoint {
        if let tableFooterView = tableView.tableFooterView {
            return CGPointMake(0, CGRectGetHeight(tableFooterView.bounds) / CGFloat(2))
        }
        return CGPointZero
    }
    
    
    // MARK: User interactions
    func longPressedView(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .Began {
            tableView.setEditing(true, animated: true)
            originalRightBarButtonItem = navigationItem.rightBarButtonItem
            let newButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action:Selector("pressedDoneButtonItem"))
            navigationItem.rightBarButtonItem = newButton
        }
    }
    
    func pressedDoneButtonItem() {
        tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = originalRightBarButtonItem
        originalRightBarButtonItem = nil
    }
    
    
    // MARK: Public methods
    func configureNavigationBarColor(navigationBarColor: UIColor, buttonsColor: UIColor) {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = buttonsColor
            navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: buttonsColor ]
            navigationBar.barTintColor = navigationBarColor
        }
    }
    
    func tableView(tableView: UITableView, customTitleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    
    // MARK: Convenience methods
    func configureTableView() {
        if tableView.tableFooterView == nil {
            tableView.tableFooterView = UIView()
        }
        tableView.backgroundColor = UIColor(red: 245/CGFloat(255), green: 245/CGFloat(255), blue: 245/CGFloat(255), alpha: 1)
    }
    
    func configureEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    func addLongPressToReorder() {
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.addTarget(self, action: Selector("longPressedView:"))
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    func attributedStringWithTitle(title: String, size: CGFloat, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(size),
            NSForegroundColorAttributeName: color
        ])
    }
    
    func tableView(tableView: UITableView, shouldDisplayCustomTitleHeaderViewForSection section: Int) -> Bool {
        let numberOfCells = self.tableView(tableView, numberOfRowsInSection: section)
        let title = self.tableView(tableView, customTitleForHeaderInSection: section)
        
        if numberOfCells == 0 || title == nil {
            return false
        } else {
            return true
        }
    }
}