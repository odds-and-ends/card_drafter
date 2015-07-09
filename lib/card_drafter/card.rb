class Card
  # Superclass for cards.
  # Cards are drawn via the draw_card method which gives an outline and then fills it
  # it gets the content for the card from the subclasses `card_contents` methods.
  FILENAME = 'cards-test'

  WIDTH = 2.5.in
  HEIGHT = 3.5.in
  RADIUS = 0.2.in

  TITLE_HEIGHT = 0.2.in
  TITLE_FONT_SIZE = 12

  PADDING = RADIUS / 2.0
  INNER_WIDTH = WIDTH - PADDING * 2
  INNER_HEIGHT = HEIGHT - PADDING * 2

  attr_accessor :pdf

  def initialize
    @pdf = CardDrafter::PDF
  end

  def draw_card
    draw_card_outline
    draw_contents
  end

  def draw_card_outline
    pdf.stroke_rounded_rectangle [0, pdf.cursor], WIDTH, HEIGHT, RADIUS
  end

  def draw_contents
    pdf.move_down RADIUS
    pdf.bounding_box([PADDING, pdf.cursor], width: INNER_WIDTH, height: INNER_HEIGHT) do
      card_contents
    end
  end

  def draw_title(title_text)
    pdf.text_box title_text, width: INNER_WIDTH,
                             height: TITLE_HEIGHT,
                             align: :center,
                             size: TITLE_FONT_SIZE,
                             style: :bold,
                             overflow: :shrink_to_fit
  end
end
