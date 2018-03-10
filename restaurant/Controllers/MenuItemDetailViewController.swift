//
//  MenuItemDetailViewController.swift
//  restaurant
//
//  Created by Jan Marten Sevenster on 08/03/2018.
//  Copyright © 2018 John Appleseed. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    var menuItem: MenuItem!
    var delegate: AddToOrderDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    // outlets
    
    @IBAction func addToOrederButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        delegate?.added(menuItem: menuItem)
    }
    // IBAction to make the interface fancy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDelegate()
    }
    // render menuitems
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupDelegate() {
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController, let orderTableViewController = navController.viewControllers.first as? OrderTableViewController {
            delegate = orderTableViewController
        }
    }
    // set up a delegate for later use
    
    func updateUI() {
        titleLabel.text = menuItem.name
        priceLabel.text = String(format: "$%.2f", menuItem.price)
        descriptionLabel.text = menuItem.description
        addToOrderButton.layer.cornerRadius = 5.0
        MenuController.shared.fetchImage(url: menuItem.imageURL)
            { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    // render and format data retrieved from the server
}
