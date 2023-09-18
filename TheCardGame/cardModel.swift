//
//  cardModel.swift
//  TheCardGame
//
//  Created by Smart Solar Nepal on 12/09/2023.
//

import Foundation

class cardModel {
    func getCards() -> [Card] {
        //    Generate an empty string of an array
        var generatedCard = [Card]()
        //    Randomize card having eight pairs of card
        for _ in 1...8{
            //        Generate random card with in the cards aray
            let randomNumber = Int.random(in: 1...13)
            //        Create two new card object
            //            creating two card because we need to make a pair for it to work
            let CardOne = Card()
            let CardTwo = Card()
            //        Name the image of the card that has jsut been assigned
            CardOne.imageName = "card\(randomNumber)"
            CardTwo.imageName = "card\(randomNumber)"
            //        Add them to the array
            generatedCard += [CardOne, CardTwo]
            print(randomNumber)
        }

        //    Randomize card with in an array
        generatedCard.shuffle()
        //    Return the array
        return generatedCard
    }
}
