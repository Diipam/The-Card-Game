//
//  CardCollectionViewCell.swift
//  TheCardGame
//
//  Created by Smart Solar Nepal on 12/09/2023.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!

    @IBOutlet weak var backImageView: UIImageView!
    var card: Card?

    func configureCell (card: Card) {
//        helps to keep track of the card cell
        self.card = card

//       set the front image to the image that the card represnts
        frontImageView.image = UIImage(named: card.imageName)

//        checkiung the status of the card and showing whether to show background image or front image accordingly

        if card.isMatched == true {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            return
        }
        else {
            frontImageView.alpha = 1
            backImageView.alpha = 1

        }

        if card.isFlipped == true{
//            show the front image view if it is flipped
            flippedUp(speed: 0)
        }
        else {
//             show background image if it is false
            flippedDown(speed: 0, delay: 0)
        }
        
    }

//    function for making the cell flipf
    func flippedUp (speed: TimeInterval = 0.3) {
        UIView.transition(from: backImageView,
                          to: frontImageView,
                          duration: speed,
                          options:[.showHideTransitionViews, .transitionFlipFromLeft],
                          completion: nil)
//        checking the status when to flippedup
        card?.isFlipped = true
    }

    func flippedDown (speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {


            UIView.transition(from: self.frontImageView,
                              to: self.backImageView,
                              duration: 0,
                              options: [.showHideTransitionViews, .transitionFlipFromLeft],
                              completion: nil)
        }
        //        checking the status for flipped down
        card?.isFlipped = false
        
    }

    func remove(){
//        make the image view invisible
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3,
                       delay: 0.5,
                       options: .curveEaseOut,
                       animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
}
 
