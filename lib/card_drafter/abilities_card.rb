class AbilitiesCard < Card
  WIDTH = 3.5.in
  HEIGHT = 2.5.in
  INNER_WIDTH = WIDTH - PADDING * 2
  INNER_HEIGHT = HEIGHT - PADDING * 2

  def initialize(card_hash)
    super()
  end

  def card_contents
  end
end
