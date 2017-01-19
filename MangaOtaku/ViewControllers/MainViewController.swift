//
//  MainViewController.swift
//  MangaOtaku
//
//  Created by Vox Long on 1/17/17.
//  Copyright © 2017 Vox Long. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class MainViewController: UIViewController {

    var genres : String = "allmanga" {
        didSet {
        }
    }
    var mangasArray = [Manga]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customSetUp()
        self.getGenresListRequest()
        if genres == "allmanga" {
            self.getAllMangas()
        } else {
            self.getMangaWithGenres()
        }
        collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionViewCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func customSetUp() {
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = Selector(("revealToggle:"))
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    private func getGenresListRequest() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading..."
        Alamofire.request(GenresApi).responseJSON { (response) in
            print(response)
            self.parseGenresJson(response: response.value)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    private func parseGenresJson(response : Any?) {
        if let genres = response as? NSArray {
            SharedCenter.sharedInstance.genres.removeAll()
            for  genre in genres {
                print(genre)
                if let dict = genre as? NSDictionary {
                    let genreObj = Genre()
                    genreObj._id = dict["_id"] as? String
                    genreObj.num = dict["num"] as? NSNumber
                    SharedCenter.sharedInstance.genres.append(genreObj)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadGenre"), object: self, userInfo: nil)
        }
    }
    
    private func getMangaWithGenres() {
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        hud.label.text = "Loading..."
        
        let requestUrl = MangasListWithGenres + self.genres
        Alamofire.request(requestUrl).responseJSON { (response) in
            print(response)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            }
            self.parseMangasList(response: response.value)
        }
    }
    
    private func getAllMangas() {
        Alamofire.request(MangasList).responseJSON { (response) in
            print(response)
            self.parseMangasList(response: response.value)
        }
    }
    
    private func parseMangasList(response : Any?) {
        if let mangas = response as? NSArray {
            var mangasArr = [Manga]()
            for  manga in mangas {
                if let dict = manga as? NSDictionary {
                    let mangaObj = Manga()
                    mangaObj._id = dict["_id"] as? String
                    mangaObj.cover = dict["cover"] as? String
                    mangaObj.title = dict["title"] as? String
                    mangaObj.lastChapter = dict["last_chapter"] as? NSNumber
                    mangaObj.author = dict["author"] as? NSArray
                    mangaObj.mangaGenres = dict["genres"] as? NSArray
                    mangaObj.mangaDes = dict["description"] as? String
                    mangasArr.append(mangaObj)
                }
            }
            self.mangasArray = mangasArr
        }
    }
}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let manga = mangasArray[indexPath.row]
        cell.cellLabel.text = manga.title
        if let coverUrl = manga.cover {
            if let url = URL(string: coverUrl) {
                cell.cellImage.sd_setImage(with: url)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangasArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width/3 - 15
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let manga = mangasArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mangaVc = storyboard.instantiateViewController(withIdentifier: "MangaDetailsViewController") as! MangaDetailsViewController
        mangaVc.manga = manga
        self.navigationController?.pushViewController(mangaVc, animated: true)
    }
}
