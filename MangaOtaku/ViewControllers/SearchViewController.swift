//
//  SearchViewController.swift
//  MangaOtaku
//
//  Created by Vox Long on 1/19/17.
//  Copyright © 2017 Vox Long. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class SearchViewController: UIViewController {
    var mangasArray = [Manga]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CollectionViewCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSearchButton(_ sender: Any) {
        searchBar.resignFirstResponder()
        if searchBar.text != nil && searchBar.text != " " {
            searchManga(serchText: searchBar.text!)
        }
    }
    
    private func searchManga(serchText : String) {
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        hud.label.text = "Searching..."
        
        Alamofire.request(SearchManga + serchText).responseJSON { (response) in
            print(response)
            self.parseMangasList(response: response.value)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            }
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension SearchViewController : UISearchBarDelegate {
    
}
