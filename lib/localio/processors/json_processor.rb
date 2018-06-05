require 'google_drive'
require 'localio/term'
require 'localio/config_store'
require 'net/http'
require 'net/https'
require 'json'

class JsonProcessor

  def self.load_localizables(platform_options, options)

    url = options[:url]

    languages_array = options[:languages]

    default_language = 'es'

    params = { channel: "all" }

    all_data = {}
    ordered_data = {}

    languages_array.each do |lang|
      url_with_language_and_params = url + "#{lang}"

      url = URI.parse(url_with_language_and_params)
      url.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(url) 
      json = JSON.parse(response.body)

      all_data.store lang.to_s, json
    end 

    languages_array.each do |lang| 
      all_data[lang.to_s].each do |key, value|
        lang_value = { lang.to_s => value }
        ordered_data.store key, lang_value unless value == nil
      end
    end

    terms = ordered_data.map { |key, value|  
      term = Term.new(key)

      value.each do |lang, tValue| 
        term.values.store lang, tValue
      end

      term
    }

    languages = Hash.new('languages')
    languages_array.each_with_index do |lang, index| 
      languages.store lang.to_s, index+1
    end

    puts 'Loaded!'

    # Return the array of terms, languages and default language
    res = Hash.new
    res[:segments] = terms
    res[:languages] = languages
    res[:default_language] = default_language

    res
  end


end
