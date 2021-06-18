# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Author.destroy_all
# Category.destroy_all

AUTHORS = Scraper.authors               # A total of 448 authors
CATEGORIES = Scraper.categories         # A total of 10 categories

def create_authors
  AUTHORS.each do |author_hash|
    Author.create(name: author_hash[:name])
  end
end

def create_categories
  CATEGORIES.each do |category|
    Category.new(name: category[:name])
  end
end

def populate_authors
  Author.all.each_with_index do |author, index|
    author_link = AUTHORS[index][:link]
    Scraper.author_quotes(author_link).each do |quote_hash|       # Each author has 60 quotes
      author.quotes.create(body: quote_hash[:body])
    end
  end
end

def populate_categories
  Category.all.each do |category|
    category_link = category.url_address
    Scraper.category_quotes(category_link).each do |quote_hash|      # Each category has 60 quotes
      author = Author.find_or_create_by(name: quote_hash[:author])
      category.quotes << Quote.find_or_create_by(author_id: author.id, body: quote_hash[:body])
    end
  end
end

# EXERT CAUTION: STEP_ONE WILL CREATE 448 AUTHORS AND 22926 QUOTES!!! CAN TAKE > 7 MINUTES TO RUN
def step_one
  create_authors
  populate_authors
end

def step_two
  create_categories
  populate_categories
end


# step_one
step_two


# link = "https://www.brainyquote.com/authors/abraham-maslow-quotes"
# link = "https://www.brainyquote.com/topics/love-quotes"
#  get_quotes_category("https://www.brainyquote.com/topics/love-quotes")
#  first = Nokogiri::HTML(open(link))
#  second = first.css("#quotesList .grid-item") 
#  third = second.collect do |i|
#  {:body => i.css("a.b-qt").text, :author => i.css("a.bq-aut").text}                             
# end
# fourth = third.uniq
# fifth = fourth.delete_if { |quote| quote[:body].blank? }
