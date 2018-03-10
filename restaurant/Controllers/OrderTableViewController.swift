//
//  OrderTableViewController.swift
//  restaurant
//
//  Created by Jan Marten Sevenster on 08/03/2018.
//  Copyright © 2018 John Appleseed. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController, AddToOrderDelegate {
    var menuItems = [MenuItem]()
    var orderMinutes: Int?
    
    @IBAction func submitTapped(_ sender: Any) {
            let orderTotal = menuItems.reduce(0.0) { (result, menuItem) -> Double in
                return result + menuItem.price
            }
            let formattedOrder = String(format: "$%.2f", orderTotal)
            
            let alert = UIAlertController(title: "Confirm Order",message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in
                self.uploadOrder()
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "DismissConfirmation" {
        menuItems.removeAll()
        tableView.reloadData()
        updateBadgeNumber()
        }
    }
    // IBActions that regulate events when submit button is tapped or unwind segue is initiated

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    // efortlessly add the cool edit button

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // only one section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    // as many rows as there are menuitems
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    // configure cells in section
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    // esthihic and consistent height adjustment to rows
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // add amazing functionality with one line of code
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            menuItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateBadgeNumber()
        }
    }
    // clear out table
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "ConfirmationSegue" {
            let orderConfirmationViewController = segue.destination as! OrederConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
        }
    }
    // pass on data needed after the segue
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                    return
                }
                cell.imageView?.image = image
            }
        }
    }
    // configure cells
    
    func added(menuItem: MenuItem) {
        menuItems.append(menuItem)
        let count = menuItems.count
        let indexPath = IndexPath(row: count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateBadgeNumber()
    }
    // add items to order list
    
    func updateBadgeNumber() {
        let badgeValue = menuItems.count > 0 ? "\(menuItems.count)" : nil
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
    // keep track of ordered dishes
    
    func uploadOrder() {
        let menuIds = menuItems.map { $0.id }
        MenuController.shared.submitOrder(menuIds: menuIds) { (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    // submit and upload order to the server
}
