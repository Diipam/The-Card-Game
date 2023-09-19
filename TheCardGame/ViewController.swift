//
//  ViewController.swift
//  TheCardGame
//
//  Created by Smart Solar Nepal on 12/09/2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var timerLabel: UILabel!



    let model = cardModel()
    var cardsArray = [Card]()
    var firstFlippedCardIndex: IndexPath?
    var timer: Timer?
    var milliseconds: Int = 80 * 1000
    var soundPlayer = soundManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardsArray = model.getCards()

        //        Making sure that the view controller is the main datasouce
        collectionView.dataSource = self
        collectionView.delegate = self

//        initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
//        fixes the bug where the time used to stop while scrolling the cell
        RunLoop.main.add(timer! , forMode: .common)
    }


//function for playing sound
    override func viewDidAppear(_ animated: Bool) {
//        Calling function for playing sound
        soundPlayer.playSound(effect: .shuffle)

    }

//    MARK: - Timer Methods

    @objc func timerFired() {

//        decrement the timer
        milliseconds -= 1

//        update the label
        let seconds: Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %..2f", seconds )

//        stop the timer if it reaches to zero
        if milliseconds == 0  {

            timerLabel.textColor = UIColor.red
            timer?.invalidate()

            //        Check if the user has completed the pair within the time limit
            checkForGameEnd()
        }
    }



    //    MARK: - COLLECTION VIEW DELICATE METHODS

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        //        return the numer of section Item
        return cardsArray.count

    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //        get the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell

        //        return the cell

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        let cardCell = cell as? CardCollectionViewCell

        // get the card from the card aray
        let card = cardsArray[indexPath.row]

        //        FINISHING configuring the cell
        cardCell?.configureCell(card: card)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        //       logic for when tapping on the the cell it flips

        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell

        // this will flip the card when we tapped in a cell
        //        using ? instead of ! because the user might not click so when thr user clicks, the ? will act as true and it flicks otherwise return nill

        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            //condition for checking when to flipped the card and this case if the card flipped is true then the card will flipped down
            cell?.flippedUp()
            soundPlayer.playSound(effect: .flip)

            //        check if this is the  first card or second card that is flipped

            if firstFlippedCardIndex == nil {
                //                this is the first card that is flipped over
                firstFlippedCardIndex = indexPath
            }
            else {
                //                second card is flipped

                //                 compariosn between two cards
                checkForMatch(secondFlippedCardIndex: indexPath)


            }

        }
    }



//        MARK: - GAME LOGIC FRO COMPARISON

        func checkForMatch( secondFlippedCardIndex: IndexPath) {

//            get the two card objects for the two indices and seee if they match

            let cardOne = cardsArray[firstFlippedCardIndex!.row]
            let cardTwo = cardsArray[secondFlippedCardIndex.row]

//            get the two collection view cell that represents the card one and two
            
            let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
            let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell

//            compare the two cards
            if cardOne.imageName == cardTwo.imageName {

//                It is a match

//                play a match sound
                soundPlayer.playSound(effect: .matched)

//                set the status and remove it
                cardOne.isMatched = true
                cardTwo.isMatched = true

                cardOneCell?.remove()
                cardTwoCell?.remove()

//                Was that the last pair ?
                checkForGameEnd()

            } else {

//                It is not a match
                cardOne.isFlipped = false
                cardTwo.isFlipped = false

//play a nomatch sound
                soundPlayer.playSound(effect: .noMatch)

//                flip them over
                cardOneCell?.flippedDown()
                cardTwoCell?.flippedDown()
            }

//            RESET THE FIRSTFLIPPEDCARDINDEX PROPERTY
        firstFlippedCardIndex = nil

        }

//MARK: - Checks whether the game has ended or not

    func checkForGameEnd() {

//        check if there is any card that is unmatched
//        assume the user has won so loop all the card to see if there is any unmatched cards

        var hasWon = true

        for card in cardsArray {
            if card.isMatched == false {
//                we found a card that is unmatched
                hasWon = false
                break
            }
        }

        if hasWon == true {
//           user has won
            showAlert(title: "Congratulation!", message: "You've won the game")

        } else {
//            user hasn't won it at all, check if there is any time left for the user to complete

            if milliseconds <= 0 {
                showAlert(title: "Time's up", message: "Better Luck Next Time")
            }
        }

        func showAlert(title: String, message: String ) {

//            create a alert
             let alert = UIAlertController(title: title
                                           , message: message,
                                           preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .destructive)
            { _ in
                self.resetGame()
            }

            alert.addAction(okAction)

//            shows the alert with the help of this
            present(alert, animated: true, completion: nil)

        }
    }

// Fucntion to reset the game after the user presses the alert button
    func resetGame() {
           // Reset game variables
           cardsArray = model.getCards()
           milliseconds = 80 * 1000
           firstFlippedCardIndex = nil

           // Reset the timer
           timer?.invalidate()
           timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
           RunLoop.main.add(timer!, forMode: .common)

           // Reset the timer label
           timerLabel.textColor = UIColor.black
           let seconds: Double = Double(milliseconds) / 1000.0
           timerLabel.text = String(format: "Time Remaining: %.2f", seconds)

           // Reload the collection view to show the shuffled cards
           collectionView.reloadData()
   }
}

