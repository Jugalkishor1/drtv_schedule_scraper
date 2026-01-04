# DRTV Schedule Scraper

A simple Ruby script that scrapes the daily TV schedule from https://www.dr.dk/drtv/tv-guide (DRTV) and exports it as JSON.

The scraper uses Selenium + Nokogiri to handle dynamic content and extract program details like channel name, start time, end time, and title.

---

## Features

- Fetches TV schedule for a given date
- Supports dynamic content using Selenium (headless Chrome)
- Extracts:
  - Channel name
  - Program title
  - Start time
  - End time
- Prints schedule to console
- Exports data to a JSON file
- Includes basic error handling for page load and scraping failures

---

## Requirements

Make sure you have the following installed:

- Ruby (2.6+)
- Google Chrome
- ChromeDriver (matching your Chrome version)

---

## Usage


### 1. Installation

Clone the repository:

```
git clone https://github.com/Jugalkishor1/drtv_schedule_scraper.git 
```

### 2. Go to the project directory.
	cd drtv_schedule_scraper

### 3. Run this command get the necesary gems.
	bundle install


### 4. Run the script.
    bin/drtv_scraper

### Or pass a specific date:
    bin/drtv_scraper 2025-01-10


---

## Output

Example console output:

DR1: 18:00 - 18:30 | TV-Avisen
DR2: 18:30 - 19:15 | Dokumentar

JSON output (tv_schedule.json):
```json
[
  {
    "channel": "DR1",
    "start_time": "18:00",
    "end_time": "18:30",
    "title": "TV-Avisen"
  }
]
```
---
## Future Improvements

Here are some planned improvements for the future. As this is my first exposure to web scraping, I am learning and experimenting more with the process. Once I gain more experience, I will implement the following enhancements as well:

- **Store scraped data in a database**: 
  This will allow for better data management and querying, making it easier to work with large datasets over time.

- **Schedule periodic scraping using cron jobs**: 
  This will automate the scraping process, allowing data to be fetched on a daily basis without manual intervention, ensuring the schedule is always up to date.

- etc

I will update this repo with these improvements as I continue learning and expanding my skills in web scraping and Ruby development.
