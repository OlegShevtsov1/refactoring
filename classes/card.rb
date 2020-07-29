class Card
  CARD_TYPE = %w[usual virtual capitalist].freeze
  def create(card_type)
    Kernel.const_get("#{card_type.capitalize}Card").new if validate?(card_type)
  end

  def validate?(card_type)
    CARD_TYPE.include?(card_type)
  end
end
