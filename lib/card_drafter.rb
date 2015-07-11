require 'yaml'
require 'prawn'
require 'prawn/measurement_extensions'
require 'card_drafter/card'
require 'card_drafter/enemy_card'
require 'card_drafter/abilities_card'

class CardDrafter
  PDF = Prawn::Document.new

  class << self
    attr_reader :yaml, :lib_directory, :filename

    def draft_cards(filename, lib_directory)
      @filename = filename
      @lib_directory = lib_directory

      load_yaml
      create_enemy_cards
      create_abilities_cards
      render_pdf
    end

    alias_method :dir, :lib_directory

    def load_yaml
      @yaml = YAML.load_file(filename)
    end

    def create_enemy_cards
      enemies = yaml['enemies']
      enemies.each do |card_hash|
        EnemyCard.new(card_hash).draw_card
      end
    end

    def create_abilities_cards
      abilities = yaml['abilities']
      abilities.each do |card_hash|
        AbilitiesCard.new(card_hash).draw_card
      end
    end

    def render_pdf
      basename = File.basename(@filename, '.*')
      PDF.render_file(basename + '.pdf')
    end
  end
end
