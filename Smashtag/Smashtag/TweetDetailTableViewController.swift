//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Luke Holoubek on 10/2/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {
    
    
    // MARK: View Controller lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let imageUrls = tweetDetail?.data["images"] else {return}
        
        for url in imageUrls {
            switch url {
            case .Image(let data):
                getImage(url: data.url)
            default:
                break
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Public API
    var tweetDetail: TweetDetail?
    
    //MARK: Private API
    var images = [UIImage]() {
        didSet{
            // If images have arrived, update the tableview to include the new images
            tableView.reloadData()
        }
    }
    
    private func getImage(url: NSURL){
        // If there's an image, this function retrieves it asynchronously and drops it in the image view
        // Gets the URL from the tweetDetail
        
        print("GETTING URGL: \(url)")
        // Send this request to a background queue
        DispatchQueue.global(qos: .userInitiated).async{ [weak self] in
            if let imageData = NSData(contentsOf: url as URL) {
                if let image = UIImage(data: imageData as Data){
                    // we have the image data as a valid UIImage; send this back to the main thread to drop in the view
                    DispatchQueue.main.async {
                        self?.images.append(image)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifer = segue.identifier {
            switch identifer{
            case "ToImageDetail":
                if let cell = sender as? ImageViewCell, let indexPath = tableView.indexPath(for: cell), let imageViewDetailController = segue.destination as? ImageDetailViewController {
                    print("Segue to image detail view...")
                    let image = images[indexPath.row]
                    imageViewDetailController.image = image
                }
            case "ToMentionSearch":
                if let tweetTableViewController = segue.destination as? TweetTableViewController {
                    print("Segue to tweet search view...")
                    if let cell = sender as? MentionTableViewCell {
                        guard let text = cell.mentionData else {return}
                        tweetTableViewController.searchText = text
                    }
                }
            default:
                break
            }
        }
    }
}


// MARK: - Table view data source
extension TweetDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numSections = tweetDetail?.numSections ?? 0
        return numSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionName = tweetDetail?.sections[section] else {return 0}
        return tweetDetail?.data[sectionName]!.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let numSections = tweetDetail?.numSections
        if numSections != 0 {
            return tweetDetail?.sections[section] ?? ""
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("TABLE LOCATION: section-\(indexPath.section)  row-\(indexPath.row) ")
        
        var identifier: String
        
        let section = tweetDetail?.sections[indexPath.section]
        
        let mentionType = tweetDetail?.data[section!]![indexPath.row]
        
        var myString: String? = ""
        var myUrl: NSURL? = NSURL(string: "")
        
        switch mentionType! {
        case .Hashtag(let data):
            identifier = "Mention"
            myString = data
        case .Url(let data):
            identifier = "Mention"
            myString = data
        case .User(let data):
            identifier = "Mention"
            myString = data
        case .Image(let data):
            identifier = "Image"
            myUrl = data.url
            let aspectRatio = data.aspectRatio
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let myCell = cell as? MentionTableViewCell{
            myCell.mentionData = myString!
        } else if let myCell = cell as? ImageViewCell{
            // If we have enough images in the images array for this cell, grab the corresponding image and put it in the cell
            if images.count > indexPath.row {
                myCell.spinner.stopAnimating()
                let image = images[indexPath.row]
                myCell.tweetDetailImageView.image = image
            } else {
                myCell.spinner.startAnimating()
            }
        }
        return cell
    }
}

//MARK: Table view delegate methods
extension TweetDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = tweetDetail?.sections[indexPath.section]
        let tweet = tweetDetail?.data[section!]?[indexPath.row]
        
        switch tweet! {
        case .Image(let data):
            // If this is an image, make the cell 200pts by default
            let width = view.frame.size.width
            let height = width / CGFloat(data.aspectRatio!)
            return height
        default:
            // Otherwise constrain it automatically to the size of the text
            return CGFloat(UITableViewAutomaticDimension)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // NOTE: we only need to handle the browser view case here. If we're transitioning to the image detail or mention search, that's handled above via segues.
        
        guard let mentionType = tweetDetail?.data[((tweetDetail?.sections[indexPath.section]))!]![indexPath.row] else {return}
        
        switch mentionType {
        case .Url(let data):
            if let url = URL(string: data){
                UIApplication.shared.open(url, options: [:], completionHandler: {(Bool) in
                    return true})
            }
        default:
            break
            
        }
    }
    
}








