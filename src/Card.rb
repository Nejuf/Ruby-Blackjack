# -*- coding: utf-8 -*-
class Card
	STANDARD_SUITS = %w( CLUBS HEARTS SPADES DIAMONDS )

	SUIT_STRINGS = {
    :CLUBS => "♣",
    :DIAMONDS => "♦",
    :HEARTS => "♥",
    :SPADES => "♠"
  }

  RANK_STRINGS = {
    1 => "A",
    2 => "2",
    3 => "3",
    4 => "4",
    5 => "5",
    6 => "6",
    7 => "7",
    8 => "8",
    9 => "9",
    10 => "10",
    11 => "J",
    12 => "Q",
    13 => "K"
  }
	attr_accessor :rank, :suit

	def initialize(rank, suit)
		@rank = rank
		@suit = suit
		@face_down = true
	end

	def is_down?
		@face_down
	end

	def flip
		@face_down = !@face_down
	end

	def show
		@face_down = false
	end

	def hide
		@face_down = true
	end

	def to_s
		SUIT_STRINGS[@suit.to_sym] + RANK_STRINGS[@rank]
	end
end