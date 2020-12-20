//
//  ViewController.swift
//  NIT_7.1
//
//  Created by Родион Сприкут on 20.12.2020.
//

import UIKit
import Nuke

struct ParsedImageUrl: Codable {
    var url: String
}

class ViewController: UIViewController {
    var imageURLs: [ParsedImageUrl] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getURLs()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionCell")
    }
    
    func getURLs() {
        guard let imgUrl = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        URLSession.shared.dataTask(with: imgUrl) { data, _, _ in
            if
                let data = data,
                let urls = try? JSONDecoder().decode([ParsedImageUrl].self, from: data)
            {
                self.imageURLs = urls.prefix(30).map { ParsedImageUrl(url: $0.url) }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }.resume()
        
    }


}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionCell", for: indexPath) as! CustomCollectionViewCell
        
        let width = self.view.frame.width / 3 - 10
        cell.updateCellSize(width: width, height: width)
        
        if imageURLs.count != 0 {
            if let imageUrl = URL(string: imageURLs[indexPath.item].url) {
                Nuke.loadImage(with: imageUrl, into: cell.imageView)
            }
        }
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "ImageVC") as! ImageViewController
        
        present(controller, animated: true)
        if let imageUrl = URL(string: imageURLs[indexPath.item].url) {
            Nuke.loadImage(with: imageUrl, into: controller.imageView)
        }
        
        if let counter = UserDefaults.standard.value(forKey: "\(indexPath.item)") {
            UserDefaults.standard.setValue(counter as! Int + 1, forKey: "\(indexPath.item)")
            controller.counterLabel.text = "Вы открывали картинку \(counter as! Int + 1) раз(а)"
        } else {
            UserDefaults.standard.setValue(1, forKey: "\(indexPath.item)")
            let counter = UserDefaults.standard.value(forKey: "\(indexPath.item)")
            controller.counterLabel.text = "Вы открывали картинку \(counter as! Int) раз"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 3 - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

