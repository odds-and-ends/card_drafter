module Prawn
  module Text
    def enemy_card_description_box(string, options={})
      options = options.dup
      options[:document] = self

      box = if p = options.delete(:inline_format)
              p = [] unless p.is_a?(Array)
              array = self.text_formatter.format(string, *p)
              Text::EnemyCardDescriptionBox.new(array, options)
            else
              Text::Box.new(string, options)
            end

      box.render
    end

    class EnemyCardDescriptionBox < Formatted::Box
      def initialize(array, options)
        super
      end

      def available_width
        if height > EnemyCard::DESCRIPTION_HEIGHT - (Card::PADDING + EnemyCard::HEALTH_SIZE + EnemyCard::DESCRIPTION_FONT_SIZE)
          EnemyCard::INNER_WIDTH - (Card::PADDING + EnemyCard::HEALTH_SIZE)
        else
          super
        end
      end
    end
  end
end
