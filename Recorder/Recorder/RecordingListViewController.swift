//
//  RecordingListViewController.swift
//  Recorder
//
//  Created by Luke Holoubek on 9/24/16.
//  Copyright © 2016 Luke Holoubek. All rights reserved.
//

import UIKit

class RecordingListViewController: UIViewController {
    
    var documents: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func refresh() {
        //get the documents directory we save recordings to
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // get the list of documents in that directory
        documents = try! FileManager.default.contentsOfDirectory(at: documentsDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        recordingList.reloadData()
    }

    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var recordingList: UITableView!
    

    
}

extension RecordingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension RecordingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        let document = documents[indexPath.row].lastPathComponent
        cell.textLabel?.text = document
        return cell
    }
}

