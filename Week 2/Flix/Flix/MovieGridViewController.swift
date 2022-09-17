//
//  MovieGridViewController.swift
//  Flix
//
//  Created by user227032 on 9/15/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
       
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 3) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
                    if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    self.movies = dataDictionary["results"] as! [[String:Any]]
                 
                    self.collectionView.reloadData()
                 
                    print(dataDictionary)
                 
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)

        cell.posterView.af.setImage(withURL: posterUrl!)
        
        cell.posterView.layer.masksToBounds = true
        cell.posterView.layer.borderWidth = 1.5
        cell.posterView.layer.borderColor = UIColor.black.cgColor

        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        // Pass the selected object to the new view controller.
        
        // Find the selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath =  collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        //  Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
