#blackjack oop
#1. Have detailed requirements or specifications in paragraph form
# 2. extract major nouns -->classes
# 3. Extract major verbs -> instance methods
# 4. Group instance methods into classes


#has a relationship => composition , achieve this through using a module.
# there is a dealer and a player. each are given two cards. the player has the chance to hit or stay. if the dealer gets 21 the player loses
require 'pry'
#dealer, player, cards, deck, 
class Card
  attr_accessor :suit, :value
  
  def initialize(s,v)
    @suit = s
    @value = v 
  end

  def to_s
  "The card is #{value} of #{card_suit}"
  end

  def card_suit
    ret_val = case suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs' 
    end
    ret_val
  end
end

class Deck
  attr_accessor :cards
  def initialize
    @cards = []
    ['H','D','S','C'].each do |suit|
     ['2','3','4','5','6','7','8','9','10','J','Q','K','A'].each do|value|
     @cards << Card.new(suit,value)
   end
 end
 scramble!
end


  def scramble!
    cards.shuffle!
  end

  def deal()
    cards.pop
  end
end


module Playcards
  
  def show_hand
    puts " ====> #{name}' cards"
    cards.each do |card|
    puts "=> #{card}"
  end
    puts "=> Total: #{total}"

  end



   def total
    value = cards.map{|card| card.value }

    total = 0
    value.each do |val|
      if val == "A"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    #correct for Aces
    value.select{|val| val == "A"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end


  def is_busted?
  total > Blackjack::BLACKJACK_AMOUNT
  end


  def add_card(new_card)
    cards << new_card
  end
end


class Player
  include Playcards
  attr_accessor :name, :cards
    
  def initialize(n)
    @name = n
    @cards = []
  end

  def show_flop
    show_hand
  end
end   


class Dealer
  include Playcards
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end
    
  def show_flop
    puts " dealer hand"
    puts "=> first card is hidden"
    puts "=> second card is #{cards[1]}"
  end
end



class Blackjack
  attr_accessor :deck, :player, :dealer
  
  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17
  
  def initialize 
    @deck = Deck.new
    @player = Player.new("mark")
    @dealer = Dealer.new
  end

  def set_player_name
    puts " whats your name?"
    player.name = gets.chomp
  end


  def deal_cards
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
  end

  def show_flop
    player.show_hand
    dealer.show_hand
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hit blackjack. #{player.name} loses."
      else
        puts "Congratulations, you hit blackjack! #{player.name} win!"
      end
      continue_playing?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations, dealer busted. #{player.name} win!"
      else
        puts "Sorry, #{player.name} busted. #{player.name} loses."
      end
    end
  end
  
  def player_turn
    puts "#{player.name}" 's turn'
     
      blackjack_or_bust?(player)
      
      while !player.is_busted?
       puts " Hit or stay. 1)Hit  2) Stay"
       response = gets.chomp

      if !['1','2'].include?(response)
        puts "Error: You must select 1 or 2"
        next
      end 

      if response == "2"
        puts "#{player.name} chose to stay"
      break
   end



  #hit
  new_card = deck.deal
  puts "Dealing card to #{player.name} : #{new_card}"
  player.add_card(new_card)
  puts "#{player.name} total is now : #{player.total}"

 

  end
   
  puts " #{player.name} stays at #{player.total}"
end


  def dealer_turn
    puts "Dealer turn"
    blackjack_or_bust?(dealer)
  while dealer.total < DEALER_HIT_MIN 
    new_card = deck.deal
    puts "dealing card to dealer : #{new_card}"
    dealer.add_card(new_card)
    puts "dealer total is now #{dealer.total}"


    blackjack_or_bust?(dealer)
  end
  puts "dealer stays at #{dealer.total}"
 end

  def who_won?
    if player.total>dealer.total
      puts "congratulations #{player.name} wins"
    elsif player.total<dealer.total 
      puts "sorry the dealer one"
    else
      puts "its a tie!"
  end
  
  def continue_playing?
    puts "would you like to play again? 1) yes 2) no"
    play_again = gets.chomp
    if play_again == '1'
    deck = Deck.new
    player.cards =[]
    dealer.cards = []
    start
  else
    puts "thanks for playing"
    exit
  end
end

   
end



  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
    continue_playing?
  end

end



game = Blackjack.new
game.start




