module ConsoleHelper
  YES_COMMAND = 'y'.freeze
  EXIT_COMMAND = 'exit'.freeze

  def put_message(message_symbol, **args)
    puts(I18n.t(message_symbol, **args))
  end

  def input
    gets.chomp
  end

  def put_error(*errors)
    errors.each { |error| put_message(error) }
  end

  def put_errors(errors)
    errors.each do |error|
      put_message(error[:error], **error[:params])
    end
  end

  def choose_card(message_symbol, cards)
    put_message(message_symbol)
    show_indexed_cards(cards)
    put_message(:exit_message)
    input
  end

  def parse_index(card_index)
    card_index.to_i - 1
  end

  def card_index_valid?(card_index, account)
    card_index >= 0 && card_index < account.cards.length
  end

  def show_indexed_cards(cards)
    cards.each_with_index do |card, index|
      put_message(:indexed_card, number: card.number, type: card.type, index: index + 1)
    end
  end
end
