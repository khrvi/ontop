require 'rubygems'
#require 'feed-normalizer'
class HomeController < ApplicationController

  def index
    #  #Define URL and Parse Feed
    #  feed_url = 'http://it.tut.by/rss.xml'
    #  rss = FeedNormalizer::FeedNormalizer.parse open(feed_url)
    ##
    ##  #Quit if no articles
    ##  exit unless rss.entries.length > 0
    ##
    ##
    $title = []
    #  $body = []
    #  $authors = []
    #  $entry_url = []
    #  #Read entries
    #  rss.entries.each do |entry|
    #	$title << entry.title
    #	$body << entry.content
    #	$authors << entry.authors.join(', ') rescue ''
    #	$entry_url << entry.urls.first
    #
    #  end
  end
  
  def faq
    @menu << :faq
  end
  
  def agb
    @menu << :agb
  end
  
  def contact
    @menu << :contact
  end
  
  protected
  def init_menu
    @menu = [:home]
  end
end
