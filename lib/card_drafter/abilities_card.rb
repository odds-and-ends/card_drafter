class AbilitiesCard < Card
  attr_accessor :pdf, :card_hash, :margin

  WIDTH = 3.5.in
  HEIGHT = 2.5.in
  INNER_WIDTH = WIDTH - PADDING * 2
  INNER_HEIGHT = HEIGHT - PADDING * 2
  ORIENTATION = :landscape
  BACK_IMAGE = 'abilities_back.jpg'

  def initialize(card_hash={})
    super()
    @pdf = CardDrafter::PDF
    @card_hash = card_hash
    @margin = CardDrafter::LANDSCAPE_MARGIN
  end

  def card_front_content
    draw_title(card_hash['title'])
    draw_image(card_hash['img'])
    draw_description_box(card_hash['abilities'])
  end

  IMAGE_WIDTH = 1.in
  IMAGE_HEIGHT = INNER_HEIGHT - 0.5.in

  def draw_image(filename)
    pdf.move_down TITLE_HEIGHT + PADDING
    left_top = [0, pdf.cursor]
    bounding_box_args = [left_top, width: IMAGE_WIDTH, height: IMAGE_HEIGHT]
    pdf.bounding_box(*bounding_box_args) do
      if image_found?(filename)
        pdf.image(image_path(filename), fit: [IMAGE_WIDTH, IMAGE_HEIGHT])
      end
      pdf.stroke_bounds
    end
  end

  DESCRIPTION_WIDTH = INNER_WIDTH - IMAGE_WIDTH - PADDING
  DESCRIPTION_LEFT = IMAGE_WIDTH + PADDING
  DESCRIPTION_FONT_SIZE = 10

  def draw_description_box(raw_text)
    styled_text = raw_text.nil? ? '' : style_text(raw_text)
    pdf.move_up IMAGE_HEIGHT
    left_top = [DESCRIPTION_LEFT, pdf.cursor]
    bounding_box_args = [left_top, width: DESCRIPTION_WIDTH, height: IMAGE_HEIGHT]
    pdf.bounding_box(*bounding_box_args) do
      pdf.text_box styled_text, width: DESCRIPTION_WIDTH - 2 * PADDING,
                                at: [PADDING, pdf.cursor - PADDING],
                                size: DESCRIPTION_FONT_SIZE,
                                inline_format: true,
                                overflow: :shrink_to_fit
      pdf.stroke_bounds
    end
  end
end
