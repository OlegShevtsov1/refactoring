class CapitalistCard < Card
  attr_reader :balance, :type
  def initialize(account)
    super

    @balance = 150
    @type = 'capitalist'
  end

  def put_tax(_amount)
    10
  end

  def withdraw_tax(amount)
    amount * 0.04
  end

  def send_tax(amount)
    amount * 0.1
  end
end
