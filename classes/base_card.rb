class BaseCard
  CARD_NUMBER_LENGTH = 16
  attr_reader :number

  def initialize
    @number = generate_card_number
  end

  def check_put(amount)
    return 'money.errors.correct_amount_money' if amount <= 0
    return 'money.errors.tax_higher' if put_tax(amount) >= amount

    :ok
  end

  def put_money(amount)
    tax = put_tax(amount)

    @balance += amount - tax

    tax
  end

  def check_withdraw(amount)
    return 'money.errors.wrong_amount' if amount <= 0
    return 'money.errors.not_enough_money_to_withdraw' if amount + withdraw_tax(amount) > balance

    :ok
  end

  def withdraw_money(amount)
    tax = withdraw_tax(amount)

    @balance -= amount + tax

    tax
  end

  def check_send(amount)
    return 'money.errors.wrong_amount' if amount <= 0
    return 'money.errors.not_enough_money_to_send' if amount + send_tax(amount) > balance

    :ok
  end

  private

  def generate_card_number
    Array.new(CARD_NUMBER_LENGTH) { rand(9) }.join
  end
end
