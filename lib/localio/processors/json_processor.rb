require 'google_drive'
require 'localio/term'
require 'localio/config_store'
require 'net/http'
require 'net/https'
require 'json'

class JsonProcessor

  def self.load_localizables(platform_options, options)
    
    url = options[:url]
    channel = options[:channel]

    puts "-- LocalioVASS: Initializing. LocalioVASS will be querying #{url} for translations --"

    languages_array = options[:languages]

    default_language = 'es'

    params = { channel: channel.to_s }

    all_data = {}
    ordered_data = {}

    languages_array.each do |lang|
      puts "-- LocalioVASS: Querying server for #{lang.to_s.capitalize!} language --"

      url_with_language_and_params = url + "#{lang}"

      url = URI.parse(url_with_language_and_params)
      url.query = URI.encode_www_form(params)

      puts "-- LocalioVASS: Using URL: #{url}"

      response = Net::HTTP.get_response(url) 
      json = JSON.parse(response.body)

      all_data.store lang.to_s, json
    end 

    puts "-- LocalioVASS: Transforming JSON to localio models --"

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
