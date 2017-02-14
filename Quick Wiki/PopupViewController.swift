//
//  PopupViewController.swift
//  Quick Wiki
//
//  Created by Jeremy Dulong on 2/12/17.
//  Copyright © 2017 1500 Fahrenheit. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    // Storyboard Outlets
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var summaryText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Updated UI on the main tread
        DispatchQueue.main.async {
            self.popupView.layer.cornerRadius = 10.0
            self.popupView.clipsToBounds = true
            
            self.summaryText.numberOfLines = 0
            self.summaryText.text = articleSummary
            
            self.titleText.text = articleTitle.capitalizingFirstLetter()
            
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
        
        self.showAnimation()
    }
    
    func showAnimation() {
        self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.removeAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
