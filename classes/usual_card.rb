class UsualCard < Card
  attr_reader :balance, :type
  def initialize(account)
    super

    @balance = 50
    @type = 'usual'
  end

  def put_tax(amount)
    amount * 0.02
  end

  def withdraw_tax(amount)
    amount * 0.05
  end

  def send_tax(_amount)
    20
  end
end
