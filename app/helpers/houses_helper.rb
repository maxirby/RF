require 'nokogiri'
require 'open-uri'

RF = "http://www.raiffeisenbank.rs"
DEF_FAKE_COUNTER = -1000

module HousesHelper

  def incrementGlobalCounter
    cfg_counter = MyConfig.find_by_name("counter")
    cfg_counter.value = (cfg_counter.value.to_i + 1).to_s
    cfg_counter.save
  end

  def getGlobalCounter
    cfg_counter = MyConfig.find_by_name("counter")
    cfg_counter.value.to_i
  end

  def markSoldHouses
    House.all.each { |house| house.counter = DEF_FAKE_COUNTER if house.counter != getGlobalCounter and house.counter >= 0; house.flag = 4 if house.counter == DEF_FAKE_COUNTER; house.save }
  end

  def markFakeSoldHouses
    House.all.each { |house| house.flag = 3 if house.counter > DEF_FAKE_COUNTER and house.counter < 0; house.save }
  end

  #take and parse content from RF site
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

    links = links.uniq
    #get nepokretnosti all from offset 0
    #doc = Nokogiri::HTML(open('http://www.raiffeisenbank.rs/code/navigate.aspx?Id=466&offset=0'))

    links.each do |page_offset|
      p "PAGE_OFFSET", page_offset
      doc = Nokogiri::HTML(open(page_offset))
      doc.css('p.newstitle > a').each do |node|
        #puts node.text.encode('utf-8'), node['href']
        #puts node.text.encode('utf-8')
        titles <<  node.text.encode('utf-8')
        p "TITLES", titles[titles.length-1]
      end
      doc.css('div.optimize').each do |node|
        #puts node.text.encode('utf-8'), node['href']
        #puts node.text.encode('utf-8')
        descriptions << node.text.encode('utf-8')
        p "DESCRIPTIONS", descriptions[descriptions.length-1]
      end
    end
    #titles.delete_at(0); descriptions.delete_at(0)
    #titles  << "vlada"; descriptions << "descriptions"
    p "SIZE", titles.length, descriptions.length
    return titles, descriptions
  end

end
