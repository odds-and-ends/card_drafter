class Card
  # Superclass for cards.
  # Cards are drawn via the draw_card method which gives an outline and then fills it
  # it gets the content for the card from the subclass's `card_contents` method.
  #
  FILENAME = 'cards-test'

  RADIUS = 0.2.in

  TITLE_HEIGHT = 0.2.in
  TITLE_FONT_SIZE = 12

  PADDING = RADIUS / 2.0

  attr_accessor :pdf, :width, :height, :inner_width, :inner_height

  def initialize
    @pdf = CardDrafter::PDF
    @width = self.class::WIDTH
    @height = self.class::HEIGHT
    @inner_width = self.class::INNER_WIDTH
    @inner_height = self.class::INNER_HEIGHT
  end

  def draw_card
    draw_card_outline
    draw_contents
  end

  def draw_card_outline
    pdf.stroke_rounded_rectangle [0, pdf.cursor], width, height, RADIUS
  end

  def draw_contents
    pdf.move_down RADIUS
    pdf.bounding_box([PADDING, pdf.cursor], width: inner_width, height: inner_height) do
      card_contents
    end
  end

  def draw_title(title_text)
    pdf.text_box title_text, width: inner_width,
                             height: TITLE_HEIGHT,
                             align: :center,
                             size: TITLE_FONT_SIZE,
                             style: :bold,
                             overflow: :shrink_to_fit
  end
end
