require_relative 'scraping'
require 'faker'
require "open-uri"
Faker::Config.default_locale = :fr

# clean DB
# puts "Destroying all users and dependencies..."
# User.destroy_all
# puts "All destroyed!"

# USERS
if User.all.size < 10
  puts "Creating 10 users..."
  10.times do
    user = User.new
    user.nickname = Faker::Name.first_name
    user.email = Faker::Internet.email
    user.password = "123456"
    file = URI.open("https://source.unsplash.com/random/?avatar,face")
    user.avatar.attach(io: file, filename: "avatar#{user.id}.png", content_type: "image/png")
    user.save!
  end
  paul = User.new(nickname: "Paul", email: "paul@gmail.com", password: "123456")
  paul_avatar = URI.open("https://static01.nyt.com/images/2020/11/02/magazine/paul-mccartney-interview-1606717610971/paul-mccartney-interview-1606717610971-mediumSquareAt3X.jpg")
  paul.avatar.attach(io: paul_avatar, filename: "paul.jpg", content_type: "image/png")
  paul.save!
  puts "Users created!"
end

# POSTS
puts "Creating posts..."
User.all.each do |user|
  rand(0..3).times do
    post = Post.new(url: scraping_links.sample)
    post.user = user
    post.title = new_title(post.url)
    post.content = new_content(post.url)
    file = URI.open("https://source.unsplash.com/random/?tech")
    post.photo.attach(io: file, filename: "photo#{post.id}.png", content_type: "image/png")
    post.save!
  end
end
puts "Posts are ready!"

# COMMENTS
puts "Adding some comments..."
Post.all.each do |post|
  users = User.all.reject { |user| user == post.user }.sample(rand(1..10))
  users.each do |user|
    comment = Comment.new
    comment.rating = rand(1..5)
    adjective = comment.rating > 2 ? Faker::Adjective.positive : Faker::Adjective.negative
    comment.content = "#{adjective}! #{Faker::Lorem.paragraph(sentence_count: rand(1..3))}"
    comment.user = user
    comment.post = post
    comment.save!
  end
end
puts "All done!"
