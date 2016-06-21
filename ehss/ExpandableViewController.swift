//
//  ExpandableViewController.swift
//  ehss
//
//  Created by IOS1-PC on 14/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit

class ExpandableViewController: UIViewController {
    
    
    static private let kTableViewCellReuseIdentifier = "TableViewCellReuseIdentifier"
    @IBOutlet weak var tableView: FZAccordionTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowMultipleSectionsOpen = true
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: ExpandableViewController.kTableViewCellReuseIdentifier)
        tableView.registerNib(UINib(nibName: "AccordionHeaderView",bundle: nil), forCellReuseIdentifier: AccordionHeaderView.kAccordionHeaderViewReuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ExpandableViewController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension ExpandableViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AccordionHeaderView.kDefaultAccordionHeaderViewHeight
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ExpandableViewController.kTableViewCellReuseIdentifier, forIndexPath: indexPath)
        cell.textLabel!.text = "Cell"
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier(AccordionHeaderView.kAccordionHeaderViewReuseIdentifier)
    }

}

extension ExpandableViewController : FZAccordionTableViewDelegate {
    
    func tableView(tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView) {
        
    }
    
    func tableView(tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView) {
        
    }
    
    func tableView(tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView) {
        
    }
    
    func tableView(tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView) {
        
    }
    
    func tableView(tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }
}
