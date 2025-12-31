require 'nokogiri'
require 'httparty'
require 'json'
require 'date'
require "byebug"
require 'selenium-webdriver'

class TVScraper
  BASE_URL = 'https://www.dr.dk/drtv/tv-guide'

  def initialize(date = Date.today.strftime('%Y-%m-%d'))
    @date = date
    @url = "#{BASE_URL}?date=#{@date}"
    @programs = []
  end

  def fetch_page
    options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
      opts.add_argument('--headless')
      opts.add_argument('--no-sandbox')
      opts.add_argument('--disable-dev-shm-usage')
    end

    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.get(@url)
    sleep(5)
    @doc = Nokogiri::HTML(@driver.page_source)
    @driver.quit
  end

  def parse_schedule
    channel_names = []
    @doc.css('.epg1__logos--logo img').each do |img|
      channel_names << img['alt']&.strip if img['alt']
    end

    schedule_container = @doc.at_css('.schedule-matrix__channels')
    return unless schedule_container

    schedule_container.css('.channel').each_with_index do |channel_div, index|
      channel_name = channel_names[index] || "Unknown Channel"

      programs_in_channel = channel_div.css('.schedule')

      channel_div.css('.schedule').each do |program_div|
        time_text = program_div.at_css('.schedule__time')&.text&.strip
        next unless time_text && time_text =~ /(\d{2}:\d{2}) - (\d{2}:\d{2})/

        start_time, end_time = $1, $2
        title = program_div.at_css('.schedule__title')&.text&.strip
        next unless title

        @programs << {
          channel: channel_name,
          start_time: start_time,
          title: title,
          end_time: end_time
        }
      end
    end
  end

  def scrape
    fetch_page
    parse_schedule
  end

  def print_to_console
    puts "TV Schedule for #{@date}:"
    @programs.each do |program|
      puts "#{program[:channel]}: #{program[:start_time]} - #{program[:end_time]} | #{program[:title]}"
    end
  end

  def export_to_json(filename = 'tv_schedule.json')
    File.write(filename, JSON.pretty_generate(@programs))
    puts "Exported to #{filename}"
  end

end

date = ARGV[0] || Date.today.strftime('%Y-%m-%d')
scraper = TVScraper.new(date)
scraper.scrape
scraper.print_to_console
scraper.export_to_json
