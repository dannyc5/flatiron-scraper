#get list of links to crawl

require 'nokogiri'
require 'open-uri'
require 'pry'
main_page = Nokogiri::HTML(open('http://students.flatironschool.com/'))
students_list = main_page.css('.home-blog ul')
student_list_item = students_list.css('.blog-thumb a')
links_to_crawl = student_list_item.map { |i| i.attributes["href"].value  }
urlmap = links_to_crawl.map { |link| "http://students.flatironschool.com/" + link  }


#Methods to make:
#1. Student Image returns a string like 
#=> "../img/students/vivian_icon.png"
#=> Use a Regex or build a method to make this a relative URL

#2. Normalize Student Quote. Quote curreny looks like: 
# => "\"It is the age of Data Mining. Embrace it with all heart.\" -- Vivian Zhang Said this."
# Need some sort of Regex or build a method to strip the \

def crawl_page(student_page)
  url = Nokogiri::HTML(open(student_page))

  #Add things in here that you want to find
  #All paths should have a url.css() call in them to work properly

  #get name, image, quote
  name = url.css('.ib_main_header').children[0].text || "name"
  image = url.css('.student_pic').first.attributes["src"].value || "image"
  quote = url.css('.textwidget h3')[0].children.text.strip || "quote"

  # Try the following line, subbing out the "[-3]" for other elements of the array
  # to get different information
  cities =  url.css('h3')[-3].parent.parent.children[5].children.map { |city| city.text.strip  }.reject(&:empty?) || "cities"
  # get biographies
  biography = url.css('h3')[1].parent.parent.children[5].text.strip || "bio"
  personal_projects = url.css('h3')[-4].parent.parent.children[5].text.strip || "projects"
  #favorite_websites = url.css('h3')[8].parent.parent.children[5].children.map { |site| site.text.gsub("-","").strip  }.reject(&:empty?)
  #favorite_websites = Hash[*favorite_websites.flatten]

  #get social media links
  social_media_array = []
 
  url.css(".social-icons a").each do |link|
    social_media_array << link.attributes["href"].value
  end
   
  url.css(".coder-cred a").each do |instance|
    social_media_array << instance.attributes["href"].value 
  end
   
  social_media_array = social_media_array.uniq || "social media"
  ### end social, needs to be able to remove one of the github instances, leaving for now to get larger functionality going


  #RETURN VALUE, FOR TESTING PURPOSES
  [name,image,quote,cities,social_media_array, biography].inspect

end
#binding.pry

final_text = ""
#For Testing purposes, run this function on Vivian and see what comes back
puts crawl_page(urlmap[0]).inspect
puts crawl_page(urlmap[2]).inspect
puts crawl_page(urlmap[3]).inspect
puts crawl_page(urlmap[5]).inspect

# test = urlmap.map do |site|
#   crawl_page(site)
# end

# puts test.join.inspect
