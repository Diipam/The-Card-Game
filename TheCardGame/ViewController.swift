//
//  ViewController.swift
//  TheCardGame
//
//  Created by Smart Solar Nepal on 12/09/2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var collectionView: UICollectionView!

    let model = cardModel()
    var cardsArray = [card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardsArray = model.getCards()

        //        Making sure that the view controller is the main datasouce
        collectionView.dataSource = self
        collectionView.delegate = self

    }

    //    MARK: - COLLECTION VIEW DELICATE METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        //        return the numer of section Item
        return cardsArray.count

    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        get the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath)

        //        TODO: FINISHING ADDING INTERFACE TO THE CELL

        //        return the cell
        return cell
    }

}
