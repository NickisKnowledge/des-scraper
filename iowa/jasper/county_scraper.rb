require 'watir'
require 'nokogiri'
# require 'httparty'
require 'pry'

require_relative 'create_csv'

@scraper_data = []

def get_county_tables(web, url)
  # browser = Watir::Browser.new
  web.goto url

  #creating url for final page
  base_url = 'https://jasper.iowaassessors.com/'
  parsed_page = Nokogiri::HTML(web.html)
  final_page_url =  base_url + parsed_page.css('div#navButtons a').last.attr('href')

  while web.url != final_page_url
    scrape_apns(web.html)

    # find a tag w/img alt as next page
    a_tag = parsed_page.css('div#navButtons a').find{|node| node.css('img').attr('alt').value == "Next Page "}

    # binding.pry
    # create url & g2 next page
    next_page_url = base_url + a_tag.attr('href')
    get_county_tables(web, next_page_url)
    # use a tag 2g2 next page
    # browser.goto
  end

  scrape_apns(web.html)

  web.quit
  # ['Parcel Number', 'Property Address', 'Property City, State Zip', 'Lot Area', 'Appraised Value']

  # browser.text_field(id: 'value').set "#{num}"
  # browser.send_keys :return
  # binding.pry
  # if browser.url.include?('Real/Index')
  #   scraper(browser.url, browser)
  # else
  #   @scraper_data << [num, 'SKIPPED']
  #   browser.quit
  # end
end

def scrape_apns(html)
  parsed_page = Nokogiri::HTML(html)

  # each pages table
  parsed_page.css('tbody tr')[1..-1].each do |tr|
    new_data = []

    #parcel Number
    num = tr.css('td a').text

    unless num == ''
      new_data << num

      #page number (if errors/shuts down)
      new_data << parsed_page.css('div#navButtons span').first.text.strip

      @scraper_data << new_data
    end
  end

  # binding.pry

  # save scrapped apns
  csv_tool(h = nil, @scraper_data.uniq)

  #clear array for next page
  @scraper_data.clear
end

# def table_scraper(html, webpage)
#   parsed_page = Nokogiri::HTML(html)
#
#   # binding.pry
#
#   parsed_page.css('tbody tr')[1..-1].each do |tr|
#     # new_data = []
#
#     #parcel Number
#     num = tr.css('td a').text
#     @scraper_data << num

    # if tr.css('td').count == 11
    #   addy = tr.css('td:nth-child(5)').text.split(', ')
    #   # 'Property Address'
    #   new_data << addy.first
    #
    #   # 'Property City, State Zip'
    #   new_data << addy.last + ', OR N/A'
    #
    #   # 'Lot Area'
    #   new_data << tr.css('td:nth-child(9)').text
    #
    #   # 'Appraised Value'
    #   new_data << tr.css('td:nth-child(10)').text
    #
    #   webpage.link(text: num).click
    #   parcel_scraper(webpage.html, new_data)
    # else
    #   binding.pry
    #   webpage.link(text: num).click
    #   parcel_scraper(webpage.html, new_data)
    # end
    # binding.pry
#
#   end
# end

# link https://beacon.schneidercorp.com/Application.aspx?AppID=325&LayerID=3398&PageTypeID=2&PageID=2260
def parcel_scraper(parcel_html, data)
  parsed_page = Nokogiri::HTML(html)

  if data.count == 5
    binding.pry

  else
    binding.pry

  end

end

browser = Watir::Browser.new
get_county_tables(browser, "https://jasper.iowaassessors.com/results.php?sort_options=0&sort=0&mode=vacantsale&sale_date1=&sale_date2=&sale_amt1=&sale_amt2=&recording1=&ilegal=&nutc1=21%2C34%2C137%2C153%2C321%2C334&ttlacre1=&ttlacre2=&location1=&class1=&maparea1=&dist1=&appraised1=&appraised2=")
