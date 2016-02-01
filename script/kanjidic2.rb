require 'nokogiri'
#require 'nori'
require 'net/http'
require 'awesome_print'
require 'open-uri'

def download
open('kanjidic2.xml.gz', 'wb') do |file|
  file << open('http://www.edrdg.org/kanjidic/kanjidic2.xml.gz').read
end
end





#download

#output = gz.read
#parser = Nori.new
#dom = parser.parse(Zlib::GzipReader.new(open('kanjidic2.xml.gz')).read)

doc = Nokogiri::XML.parse(Zlib::GzipReader.new(open('kanjidic2.xml.gz')))

kanji = { }
doc.search('character').each do |character|
  literal = character.at('literal').text
  kanji[literal] = {} unless kanji.has_key?(literal)

  current_kanji = kanji[literal]
  grade = character.at('grade')&.text
  current_kanji[:grade] = grade if grade
  
  character.search('dic_ref').each do |dict_ref| 
    dict_type = dict_ref['dr_type']
    reference = dict_ref.text
    current_kanji[dict_type.to_sym] = reference
  end  
  character.search('stroke_count').each do |stroke_count| 
    current_kanji[:stroke_count] = stroke_count.text.to_i
  end
  character.search('reading[r_type="ja_on"]').each do |on_yomi|  
    current_kanji[:on_yomi] = [] unless current_kanji.has_key?(:on_yomi)
    current_kanji[:on_yomi] << on_yomi.text
  end
  character.search('reading[r_type="ja_kun"]').each do |kun_yomi|  
    current_kanji[:kun_yomi] = [] unless current_kanji.has_key?(:kun_yomi)
    current_kanji[:kun_yomi] << kun_yomi.text
  end  
  jlpt = character.at('jlpt')&.text
  current_kanji[:jlpt] = jlpt.to_i if jlpt
  
    
end  

ap kanji['花']

