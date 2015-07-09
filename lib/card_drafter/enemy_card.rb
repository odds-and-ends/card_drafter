class EnemyCard < Card
  attr_accessor :pdf, :card_hash, :image_path

  IMAGE_HEIGHT = 1.in
  IMAGE_WIDTH = INNER_WIDTH / 2.0

  def initialize(card_hash)
    super()
    @pdf = CardDrafter::PDF
    @card_hash = card_hash
    determine_image_path
  end

  def card_contents
    draw_title(card_hash['title'])
    draw_image
    # draw_stats_boxes
    # draw_description_box
    # draw_health_stat
  end

  def draw_image
    pdf.move_down TITLE_HEIGHT
    pdf.bounding_box([0, pdf.cursor], width: IMAGE_WIDTH, height: IMAGE_HEIGHT) do
      pdf.image image_path, width: IMAGE_WIDTH, height: IMAGE_HEIGHT  if image_found?
      pdf.stroke_bounds
    end
  end

  def determine_image_path
    @image_path = if card_hash['img']
                    CardDrafter.dir + '/' + card_hash['img']
                  else
                    ''
                  end
  end

  def image_found?
    File.file?(image_path)
  end
end
