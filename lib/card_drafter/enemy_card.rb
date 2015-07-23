class EnemyCard < Card
  attr_accessor :pdf, :card_hash, :margin

  WIDTH = 2.5.in
  HEIGHT = 3.5.in
  INNER_WIDTH = WIDTH - PADDING * 2
  INNER_HEIGHT = HEIGHT - PADDING * 2
  ORIENTATION = :portrait
  BACK_IMAGE = 'enemy_back.jpg'

  def initialize(card_hash={})
    super()
    @pdf = CardDrafter::PDF
    @card_hash = card_hash
    @margin = CardDrafter::PORTRAIT_MARGIN
  end

  def card_front_content
    draw_title(card_hash['title'])
    draw_image(card_hash['img'])
    draw_stats_boxes
    draw_description_box(card_hash['abilities'])
    draw_health_stat(card_hash['health'].to_s)
    draw_action_stat(card_hash['action'])
  end

  IMAGE_HEIGHT = 1.in
  IMAGE_WIDTH = 1.in

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

  STATS_WIDTH = 1.25.in
  STATS_LEFT = INNER_WIDTH / 2.0 - 6
  STAT_SIZE = 20
  STAT_FONT_SIZE = 14
  STAT_SPACING = PADDING * 1.5

  def draw_stats_boxes
    pdf.move_up IMAGE_HEIGHT
    left_top = [STATS_LEFT, pdf.cursor]
    bounding_box_args = [left_top, { width: STATS_WIDTH, height: IMAGE_HEIGHT }]
    pdf.bounding_box(*bounding_box_args) do
      %w(aim brawn grace charm brains grit).each_with_index do |stat, i|
        draw_stat_icon(stat, i)
        draw_stat_text(stat, i)
        move_cursor(i)
      end
    end
  end

  DESCRIPTION_HEIGHT = 1.5.in
  DESCRIPTION_FONT_SIZE = 10

  def draw_description_box(raw_text)
    styled_text = raw_text.nil? ? '' : style_text(raw_text)
    pdf.move_down PADDING
    left_top = [0, pdf.cursor]
    bounding_box_args = [left_top, { width: INNER_WIDTH, height: DESCRIPTION_HEIGHT }]
    pdf.bounding_box(*bounding_box_args) do
      pdf.move_down PADDING
      pdf.enemy_card_description_box(styled_text,
                                     width: INNER_WIDTH - 2 * PADDING,
                                     height: DESCRIPTION_HEIGHT,
                                     at: [PADDING, pdf.cursor],
                                     size: DESCRIPTION_FONT_SIZE,
                                     inline_format: true,
                                     overflow: :shrink_to_fit)
      pdf.stroke_bounds
    end
  end

  HEALTH_SIZE = 0.5.in
  HEALTH_FONT_SIZE = 16

  def draw_health_stat(health)
    left_top = [pdf.bounds.right - HEALTH_SIZE, pdf.cursor + HEALTH_SIZE]
    bounding_box_args = [left_top, { width: HEALTH_SIZE, height: HEALTH_SIZE }]
    pdf.bounding_box(*bounding_box_args) do
      pdf.text health, size: HEALTH_FONT_SIZE, style: :bold, align: :center, valign: :center
      pdf.stroke_bounds
    end
  end

  ACTION_LEFT = 20
  ACTION_SPACING = 30
  ACTION_CIRCLE_SIZE = 5

  def draw_action_stat(action)
    pdf.move_down PADDING * 2
    5.times do |i|
      if i + 1 <= action
        pdf.fill_circle [ACTION_LEFT + ACTION_SPACING*i, pdf.cursor], ACTION_CIRCLE_SIZE
      else
        pdf.stroke_circle [ACTION_LEFT + ACTION_SPACING*i, pdf.cursor],ACTION_CIRCLE_SIZE
      end
    end
  end

  private

  def draw_stat_icon(stat, index)
    filename = stat + '.png'
    pdf.image(icon_image_path(filename), fit: [STAT_SIZE, STAT_SIZE],
                                          at: [stat_icon_left(index), pdf.cursor])
  end

  def draw_stat_text(stat, index)
    pdf.move_down STAT_SIZE / 2.0 + STAT_FONT_SIZE / 4.0
    pdf.draw_text(stat_text(stat), at: [stat_text_left(index), pdf.cursor])
  end

  def stat_icon_left(index)
    index < 3 ? 0 : (STATS_WIDTH / 2.0 - 2)
  end

  def stat_text_left(index)
    stat_icon_left(index) + STAT_SIZE + PADDING
  end

  def stat_text(stat)
    card_hash['stats'][stat].to_s
  end

  def move_cursor(index)
    if index == 2
      pdf.move_up( STAT_SIZE * 3 + 2 ) if index == 2
    else
      pdf.move_down STAT_SPACING
    end
  end
end
