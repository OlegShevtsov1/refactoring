class UsualCard < Card
  PUT_TAX = 2
  WITHDRAW_TAX = 5
  SEND_TAX = 20

  attr_reader :balance, :type

  def initialize(account)
    super

    @balance = 50
    @type = 'usual'
  end

  def put_tax(amount)
    amount * PUT_TAX / 100
  end

  def withdraw_tax(amount)
    amount * WITHDRAW_TAX / 100
  end

  def send_tax(_amount)
    SEND_TAX
  end
end
