require 'nokogiri'
require 'open-uri'

RF = "http://www.raiffeisenbank.rs"

module HousesHelper

  def getRfInformation
    link = ""
    links = []
    titles = []
    descriptions = []


    #main page to reach 'nepokretnosti'
    doc = Nokogiri::HTML(open(RF))

    doc.css('#mainMenu > ul > li > a').each do |node|
      #puts node.text, node['href']
      if node.text.encode("utf-8") == "Prodaja nepokretnosti".encode("utf-8"); link = node['href']; puts node['href']; end
    end

    link = RF + link

    #'nepokretnosti' page to reach each page, except first one which has offset 0
    #doc = Nokogiri::HTML(open('http://www.raiffeisenbank.rs/code/navigate.aspx?Id=466'))

    doc = Nokogiri::HTML(open(link))

    doc.css('div.navigationchain > a').each do |node|
      #puts node.text, node['href']
      links << RF + node['href']
    end

    #offset=0 is the same as link
    links.insert(0, link)

    #get nepokretnosti all from offset 0
    #doc = Nokogiri::HTML(open('http://www.raiffeisenbank.rs/code/navigate.aspx?Id=466&offset=0'))

    links.each do |page_offset|
      doc = Nokogiri::HTML(open(page_offset))
      doc.css('p.newstitle > a').each do |node|
        #puts node.text.encode('utf-8'), node['href']
        #puts node.text.encode('utf-8')
        titles <<  node.text.encode('utf-8')
      end
      doc.css('div.optimize').each do |node|
        #puts node.text.encode('utf-8'), node['href']
        #puts node.text.encode('utf-8')
        descriptions << node.text.encode('utf-8')
      end
    end
    return titles, descriptions
  end

end
