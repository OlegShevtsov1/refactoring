module CardHelper
  private

  def show_cards
    if @current_account.cards.any?
      @current_account.cards.each do |card|
        puts "- #{card.number}, #{card.type}"
      end
    else
      message('card.errors.no_active_cards')
    end
  end

  def create_card
    loop do
      card_type = card_type_input
      break if card_type == 'exit'

      card = Card.new.create(card_type)
      return @current_account.save_card(card) if card

      message('card.errors.wrong_card_type')
    end
  end

  def destroy_card
    return message('card.no_active_cards') unless @current_account.cards.any?

    loop do
      message('card.if_you_want_to_delete')
      print_cards
      answer = gets.chomp
      break if answer == 'exit'

      return confirmation_delete_card(answer) if check_card_ordinal_number(answer)

      message('card.errors.wrong_number')
    end
  end

  def card_type_input
    message('card.create_card')
    message('card.press_exit')
    gets.chomp
  end

  def print_cards
    @current_account.cards.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index + 1}" }
    message('card.press_exit')
  end

  def confirmation_delete_card(answer)
    message('card.confirmation_delete_card', number: @current_account.cards[answer&.to_i.to_i - 1].number)
    return if gets.chomp != 'y'

    @current_account.destroy_card(answer)
  end

  def check_card_ordinal_number(answer)
    answer&.to_i.to_i <= @current_account.cards.length && answer&.to_i.to_i.positive?
  end
end
