module MoneyHelper
  def put_money
    return message('card.errors.no_active_cards') unless @current_account.cards.any?

    message('money.choose_card_for_putting')
    current_card_set(choose_card)
    amount_money = input_amount_money_put

    return unless pass_check?(@current_card, :check_put, amount_money)

    tax = @current_card.put_money(amount_money)
    @current_account.save_changes
    message('money.money_put_on', amount: amount_money, card_number: @current_card.number)
    message('money.balance_put_on', balance: @current_card.balance, tax: tax)
  end

  def withdraw_money
    return message('card.errors.no_active_cards') unless @current_account.cards.any?

    message('money.choose_card_for_withdrawing')
    current_card_set(choose_card)
    amount_money = input_amount_money_withdraw

    return unless pass_check?(@current_card, :check_withdraw, amount_money)

    tax = @current_card.withdraw_money(amount_money)
    @current_account.save_changes
    message('money.money_withdrawn', amount: amount_money, card_number: @current_card.number)
    message('money.balance_withdrawn', balance: @current_card.balance, tax: tax)
  end

  def send_money
    return message('card.errors.no_active_cards') unless @current_account.cards.any?

    message('money.choose_card_for_sending')
    current_card_set(choose_card)

    recipient_card = input_recipient_card
    return message('money.errors.correct_number_of_card') if BaseCard::CARD_NUMBER_LENGTH != recipient_card.length

    if recipient_card_set(recipient_card)
      send_money_transfer
    else
      message('card.errors.no_card_found', number: recipient_card)
    end
  end

  private

  def choose_card
    print_cards
    loop do
      answer = gets.chomp
      break if answer == 'exit'

      return answer if check_card_ordinal_number(answer)

      message('card.errors.wrong_number') unless check_card_ordinal_number(answer)
    end
  end

  def input_amount_money_put
    message('money.amount_money_put')
    gets.chomp&.to_i
  end

  def input_amount_money_withdraw
    message('money.amount_money_withdraw')
    gets.chomp&.to_i
  end

  def current_card_set(answer)
    @current_card = @current_account.cards[answer&.to_i.to_i - 1]
  end

  def pass_check?(card, check, amount)
    status = card.send(check, amount)

    return true if status == :ok

    message(status)
    false
  end

  def input_recipient_card
    message('money.enter_the_recipient_card')
    gets.chomp
  end

  def recipient_card_set(recipient_card)
    @current_recipient_card = @account.accounts.map(&:cards).flatten.detect { |card| card.number == recipient_card }
  end

  def send_money_transfer
    amount_money = input_amount_money_withdraw

    return unless pass_check?(@current_card, :check_send, amount_money)

    tax_withdraw = @current_card.withdraw_money(amount_money)
    message('money.money_withdrawn', amount: amount_money, card_number: @current_card.number)
    message('money.balance_withdrawn', balance: @current_card.balance, tax: tax_withdraw)

    tax_put = @current_recipient_card.put_money(amount_money)
    message('money.money_put_send', amount: amount_money, card_number: @current_recipient_card.number)
    message('money.balance_put_on', balance: @current_recipient_card.balance, tax: tax_put)

    @current_account.save_changes
  end
end
