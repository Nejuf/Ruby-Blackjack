# Ruby Blackjack #

A casino-style game of [Blackjack](http://en.wikipedia.org/wiki/Blackjack) played on the command-line.

Ruby v1.8.7

## How to Play: ##
- Get as close as possible to 21 points without going over ("bust").
- Face-cards are worth 10 points
- Aces are 11 points (or 1 if 11 would cause "bust").
- Have more points without "busting" than the dealer to win.
- You start out with two cards (one face-up, one face-down).
- Choose "hit" to draw another card, or "stay" to use the cards you have.
- A tie with the dealer is a "push"; no money is lost or won.
- Double-down - double your bet, and receive one, and only one, more card.  Non-controlling players may choose to double their best as well.
- Split - if your first two non-ace cards are the same value, you may split them into two separate hands, and play both.  An additional bet must be added to the new hand.

## Setup: ##
- Standard 52-card deck
- $1000 per player
- Dealer hits on 16 or less; stays otherwise
- Payout is 1:1, or 1.5:1 on blackjack

## Features to Add: ##
- Surrender
- Insurance
- Color
- Optional controlling player turn-style
- Localization