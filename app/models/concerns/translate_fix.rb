module TranslateFix
  extend ActiveSupport::Concern

  included do
    scope :with_fallback_translations, -> { joins(:translations)
     .joins("INNER JOIN (
              SELECT #{fk_column},
                CASE
                  WHEN MAX(CASE
                              WHEN locale = '#{Globalize.fallbacks[0]}' then 1 -- default language
                              WHEN locale = '#{Globalize.fallbacks[1]}' then 0 -- fallback
                            END) = 1
                   THEN '#{Globalize.fallbacks[0]}'
                   ELSE '#{Globalize.fallbacks[1]}'
                 END as pref_loc
               FROM #{self.translations_table_name}
              GROUP BY #{fk_column} ) pref ON pref.#{fk_column}= #{translations_table_name}.#{fk_column}
                                          AND pref.pref_loc = #{translations_table_name}.locale") }

    def self.fk_column
      self.to_s.downcase + '_id'
    end
  end
end
