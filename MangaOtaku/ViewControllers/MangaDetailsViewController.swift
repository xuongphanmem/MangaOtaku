//
//  MangaDetailsViewController.swift
//  MangaOtaku
//
//  Created by Vox Long on 1/19/17.
//  Copyright © 2017 Vox Long. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class MangaDetailsViewController: UIViewController {

    var chapters : [Chapter] = [Chapter]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var manga : Manga!
    @IBOutlet weak var mangaDe: UILabel!
    @IBOutlet weak var mangaTitle: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: GenreTableViewCell.constants.name, bundle: Bundle.main), forCellReuseIdentifier: GenreTableViewCell.constants.identifier)
        // Do any additional setup after loading the view.
        mangaDe.text = manga.mangaDes
        mangaTitle.text = manga.title
        if let coverUrl = manga.cover {
            if let url = URL(string: coverUrl) {
                cover.sd_setImage(with: url)

            }
        }
        var genresString : String = ""
        if let genres = manga.mangaGenres {
            for obj in genres {
                if genres.index(of: obj) == 0 {
                    genresString = genresString  + (obj as! String)

                } else {
                    genresString = genresString + "," + (obj as! String)

                }
            }
            genre.text = genresString
        }
        
        var authorsString : String = ""
        if let authors = manga.author {
            for obj in authors {
                if authors.index(of: obj) == 0 {
                    authorsString = authorsString  + (obj as! String)
                    
                } else {
                    authorsString = authorsString + "," + (obj as! String)
                    
                }
            }
            author.text = authorsString
        }
        
        //start get chapters 
        requestGetChapter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func requestGetChapter() {
        let hud = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        hud.label.text = "Loading..."
        
        Alamofire.request(MangaChapters + manga._id!).responseJSON { (response) in
            print(response)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.navigationController!.view, animated: true)
            }
            self.parseChapters(response: response.value)
        }

    }
    
    private func parseChapters(response : Any?) {
        if let chapters = response as? NSArray {
            var chaptersArr = [Chapter]()
            for  chapter in chapters {
                if let dict = chapter as? NSDictionary {
                    let chapterObj = Chapter()
                    chapterObj._id = dict["_id"] as? String
                    chapterObj.content = dict["content"] as? NSArray
                    chaptersArr.append(chapterObj)
                }
            }
            self.chapters = chaptersArr
        }

    }

}

extension MangaDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenreTableViewCell.constants.identifier, for: indexPath) as! GenreTableViewCell
        cell.cellLabel.text = "chapter" + String(format: "%d", (indexPath.row + 1))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let chapterVC = storyboard.instantiateViewController(withIdentifier: "ChapterViewController") as! ChapterViewController
        let chapter = chapters[indexPath.row]
        chapterVC.chapter = chapter
        self.navigationController?.pushViewController(chapterVC, animated: true)
    }
    
}
