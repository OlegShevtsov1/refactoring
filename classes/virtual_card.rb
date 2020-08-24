class VirtualCard < Card
  PUT_TAX = 1
  WITHDRAW_TAX = 88
  SEND_TAX = 1

  attr_reader :balance, :type

  def initialize(account)
    super

    @balance = 150
    @type = 'virtual'
  end

  def put_tax(_amount)
    PUT_TAX
  end

  def withdraw_tax(amount)
    amount * WITHDRAW_TAX / 100
  end

  def send_tax(_amount)
    SEND_TAX
  end
end
