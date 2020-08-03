class Card
  CARD_TYPE = %w[usual virtual capitalist].freeze
  CARD_NUMBER_LENGTH = 16
  attr_reader :number, :account, :errors

  def initialize(account = nil)
    @number = generate_card_number
    @account = account
    @errors = []
  end

  def create(card_type, account)
    Kernel.const_get("#{card_type.capitalize}Card").new(account) if validate?(card_type)
  end

  def put_money(amount, tax)
    return @errors << 'money.errors.correct_amount_money' if amount <= 0
    return @errors << 'money.errors.tax_higher' if tax >= amount

    @balance += amount - tax
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

  def validate?(card_type)
    CARD_TYPE.include?(card_type)
  end
end
