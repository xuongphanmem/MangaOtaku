//
//  MenuViewController.swift
//  MangaOtaku
//
//  Created by Vox Long on 1/17/17.
//  Copyright © 2017 Vox Long. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: GenreTableViewCell.constants.name, bundle: Bundle.main), forCellReuseIdentifier: GenreTableViewCell.constants.identifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(MenuViewController.reloadTableView), name: NSNotification.Name(rawValue: "reloadGenre"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadGenre"), object: nil)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GenreTableViewCell.constants.identifier, for: indexPath) as! GenreTableViewCell
        if indexPath.row == 0 {
            cell.cellLabel.text = "All Manga"
        } else {
            let genre = SharedCenter.sharedInstance.genres[indexPath.row]
            cell.cellLabel.text = genre._id
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedCenter.sharedInstance.genres.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GenreTableViewCell.constants.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        if indexPath.row == 0 {
            mainVC.genres = "allmanga"
        } else {
            let genre = SharedCenter.sharedInstance.genres[indexPath.row]
            mainVC.genres = genre._id!
        }
        let nav = UINavigationController(rootViewController: mainVC)
        self.revealViewController().setFront(nav, animated: true)
    }
}
