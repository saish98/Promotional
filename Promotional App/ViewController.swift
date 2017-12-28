//
//  ViewController.swift
//  Promotional App
//
//  Created by Heady on 26/12/17.
//  Copyright © 2017 Heady. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var docRef: DocumentReference!
    private var arrayData: [Event]?
    var refreshControl: UIRefreshControl!
    var selectedEvent: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initObjects()
        initFirebase()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       fetchData()
    }

    func initObjects() {
        arrayData = []
        self.title = "Event List"
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            self.tableView.addSubview(refreshControl)
        }
    }
    func initFirebase() {
        docRef = Firestore.firestore().collection(Constant.collectionName).document(Constant.documentName)
    }
    
    func registerCell() {
        self.tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier:  Constant.cellId)
        self.tableView.tableFooterView = UIView()
    }
    
    func saveData(){
        let docData:Dictionary = [
            "eventArray": [["name":"Event1","small_desc":"This is small desc"],["name":"Event2","small_desc":"This is small desc"],["name":"Event3","small_desc":"This is small desc"],["name":"Event4","small_desc":"This is small desc"]]]
        docRef.setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func fetchData() {
        docRef.addSnapshotListener{(docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let data = docSnapshot.data()
            let tempEventData: [Any] = data["eventArray"] as! [Any]
            if tempEventData.count > 0 {
                self.arrayData?.removeAll()
                tempEventData.forEach({ (dict) in
                    let event = Event (dict: dict as! [String : String])
                    self.arrayData?.append(event)
                })
                print("fetch data \(self.arrayData ?? [])")
                self.tableView.reloadData()
            }
        }
    }
    
    func loadData() {
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let data = docSnapshot.data()
            let tempEventData: [Any] = data["eventArray"] as! [Any]
            if tempEventData.count > 0 {
                self.arrayData?.removeAll()
                tempEventData.forEach({ (dict) in
                    let event = Event (dict: dict as! [String : String])
                    self.arrayData?.append(event)
                })
                print("load data \(self.arrayData ?? [])")
                self.tableView.reloadData()
            }
        }
    }

    @objc func updateData() {
        fetchData()
        self.refreshControl?.endRefreshing()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData!.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventCell = self.tableView.dequeueReusableCell(withIdentifier: Constant.cellId) as! EventCell
        let event: Event = self.arrayData![indexPath.row]
        cell.labelName?.text = event.name
        cell.labelDescription?.text = event.small_description
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let eventDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: Constant.eventDetailViewControllerId) as! EventDetailViewController
        eventDetailViewController.event = self.arrayData![indexPath.row]
        self.navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
