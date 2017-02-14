//
//  ViewController.swift
//  Quick Wiki
//
//  Created by Jeremy Dulong on 11/22/16.
//  Copyright © 2016 1500 Fahrenheit. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import AVFoundation
import QuartzCore

// Global Variable Declaration
var articleSummary: String = "Summary"
var articleTitle: String = "Title"

class ViewController: UIViewController, UITextFieldDelegate {

    // Storyboard Outlets
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var summarizeButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    
    // Spinner Declaration
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    // Video Player Declaration
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
   
    // Format Article URLs
    var articleNameFormatted : String = ""
    let urlString : String = "http://api.smmry.com/&SM_API_KEY=B230239FF7&SM_URL="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchText.delegate = self
        
        // UI Formatting
        self.infoView.layer.cornerRadius = 10.0
        self.infoView.clipsToBounds = true
        self.infoView.alpha = 0.0
        
        // Load the video background from the app bundle.
        let URL = Bundle.main.url(forResource: "background", withExtension: "mp4")
        player = AVPlayer(url: URL!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.frame = view.layer.frame
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        player.play()
        view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
    }
    
    // Close Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Loop Background
    func playerItemReachEnd(notification: NSNotification) {
        player.seek(to: kCMTimeZero)
    }

    // Light Status Bar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // Memory Warning Handler
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func summarizeArticle() -> Void {
        
        // Format text for API call
        let formatText = (searchText.text?.replacingOccurrences(of: " ", with: "_"))!
        articleNameFormatted = ("https://en.wikipedia.org/wiki/" + formatText)
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: urlString + articleNameFormatted) as URL!
        request.httpMethod = "POST"
        let url = request.url
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    
                    // Parse Data
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    articleTitle = self.searchText.text!
                    articleSummary = parsedData["sm_api_content"] as! String
                    print(articleSummary)
                    
                    DispatchQueue.main.async {
                        // Stop Spinner
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.alpha = 0.0
                        
                        // Create Popup
                        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopupVC") as! PopupViewController
                        popupVC.view.frame = self.view.frame
                        self.addChildViewController(popupVC)
                        self.view.addSubview(popupVC.view)
                        popupVC.didMove(toParentViewController: self)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            }.resume()
    }
    
    
    @IBAction func summarizeButtonPressed(_ sender: Any) {
        
        // Hide Keyboard & Begin Data Parse
        self.view.endEditing(true)
        summarizeArticle()
        
        // Loading Spinner
        self.activityIndicator.alpha = 1.0
        self.view.addSubview(activityIndicator)
        self.activityIndicator.center = view.center
        self.activityIndicator.startAnimating()
    }

    @IBAction func infoButtonPressed(_ sender: UIButton) {
        if self.infoView.alpha == 0.0 {
            self.infoView.alpha = 1.0
        } else {
            self.infoView.alpha = 0.0
        }
    }
    
}

