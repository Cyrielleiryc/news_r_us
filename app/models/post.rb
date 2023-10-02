require "open-uri"

class Post < ApplicationRecord
  # associations
  belongs_to :user
  has_many :comments, dependent: :destroy

  # validations
  validates :title, :content, :url, presence: true

  # image with cloudinary
  has_one_attached :photo

  # barre de recherche
  include PgSearch::Model
  pg_search_scope :search_by_title_and_content, against: %i[title content], using: { tsearch: { prefix: true } }

  # méthode d'instance pour calculer la moyenne des notes
  def ratings_average
    rates = []
    self.comments.each do |comment|
      rates << comment.rating
    end
    total = rates.sum
    average = total.fdiv(rates.size)
    return average.round(1)
  end

  # Add a default photo
  after_commit :add_default_photo, on: %i[create]

  private

  def add_default_photo
    unless photo.attached?
      file = URI.open("https://source.unsplash.com/random/?news")
      self.photo.attach(io: file, filename: "photo-default.png", content_type: "image/png")
      self.save
    end
  end
end
