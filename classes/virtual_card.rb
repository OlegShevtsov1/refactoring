class VirtualCard < Card
  attr_reader :balance, :type
  def initialize(account)
    super

    @balance = 150
    @type = 'virtual'
  end

  def put_tax(_amount)
    1
  end

  def withdraw_tax(amount)
    amount * 0.88
  end

  def send_tax(_amount)
    1
  end
end
