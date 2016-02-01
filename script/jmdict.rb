require 'nokogiri'
require 'net/http'
require 'awesome_print'
require 'open-uri'

def download
open('JMdict', 'wb') do |file|
  # http://ftp.monash.edu.au/pub/nihongo/JMdict.gz
  file << open('http://ftp.monash.edu.au/pub/nihongo/JMdict.gz').read
end
end


#download


doc = Nokogiri::XML.parse(open('JMdict'))

doc.search('entry').each do |entry|
  entry.search('keb').each do |kanji_element|
    ap kanji_element
  end
  entry.search('reb').each do |reading_element|
    ap reading_element
  end  
  entry.search('gloss').each do |gloss|
    ap gloss.text
  end  
  
  ap "-----"
end


