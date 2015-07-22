require 'yaml'
require 'prawn'
require 'prawn/measurement_extensions'
require 'card_drafter/card'
require 'card_drafter/enemy_card'
require 'card_drafter/abilities_card'

class CardDrafter
  PDF = Prawn::Document.new(skip_page_creation: true)
  CARD_SPACING = 0
  # TODO: Code smell here, perhaps refactor as LandscapeCard and PortraitCard
  # parent classes.
  PORTRAIT_MARGIN = [0.25.in, 0, 0, 0.5.in]
  LANDSCAPE_MARGIN = [0.5.in, 0, 0, 0.25.in]

  class << self
    attr_accessor :left_edge
    attr_reader :yaml, :lib_directory

    def draft_cards(lib_directory)
      @lib_directory = lib_directory
      @left_edge = 0

      load_yamls
      create_enemy_cards
      create_abilities_cards
      render_pdf
    end

    alias_method :dir, :lib_directory

    def load_yamls
      @enemies = YAML.load_file('enemies.yml')
      @abilities = YAML.load_file('abilities.yml')
    end

    def create_enemy_cards
      start_new_page(:portrait)
      @enemies.each_with_index do |card_hash, index|
        card = EnemyCard.new(card_hash)
        card.draw!
        move_cursor_for_new_card(index, card)
      end
    end

    def create_abilities_cards
      PDF.start_new_page(layout: :landscape, margin: LANDSCAPE_MARGIN)
      @abilities.each_with_index do |card_hash, index|
        card = AbilitiesCard.new(card_hash)
        card.draw!
        move_cursor_for_new_card(index, card)
      end
    end

    def render_pdf
      PDF.render_file('cards_draft.pdf')
    end

    def move_cursor_for_new_card(index, card)
      if need_to_move_to_top?(index)
        PDF.move_cursor_to PDF.bounds.top
        @left_edge += card.width + CARD_SPACING
      end
      if need_to_move_to_new_page?(index)
        PDF.start_new_page(layout: card.orientation, margin: card.margin)
        @left_edge = 0
      end
    end

    def need_to_move_to_top?(index)
      (index + 1) % 3 == 0 && index > 0
    end

    def need_to_move_to_new_page?(index)
      (index + 1) % 9 == 0 && index > 0
    end

    def start_new_page(layout)
        CardBacksPage.new(layout, :default) #make this stuff, put this on a new branch ok?
        PDF.start_new_page(layout: layout, margin: const_get(layout.to_s.upcase + '_MARGIN')
    end
  end
end
