require 'google_drive'
require 'localio/term'
require 'localio/config_store'

class GoogleDriveProcessor

  def self.load_localizables(platform_options, options)

    url = options[:url]
    languages = options[:languages]

    puts url

    puts languages

    languages.each do |lang|
      
    end 

    # terms = []
    # first_term_row = first_valid_row_index+1
    # last_term_row = last_valid_row_index-1

    # for row in first_term_row..last_term_row
    #   key = worksheet[row, 1]
    #   unless key.to_s == ''
    #     term = Term.new(key)
    #     languages.each do |lang, column_index|
    #       term_text = worksheet[row, column_index]
    #       term.values.store lang, term_text
    #     end
    #     terms << term
    #   end
    # end

    puts 'Loaded!'

    # Return the array of terms, languages and default language
    res = Hash.new
    res[:segments] = terms
    res[:languages] = languages
    res[:default_language] = default_language

    res
  end

end
