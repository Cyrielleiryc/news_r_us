require "open-uri"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # validations
  validates :nickname, presence: true
  validates :nickname, length: { maximum: 50 }

  # avatar with cloudinary
  has_one_attached :avatar

  # Add a default avatar
  after_commit :add_default_avatar, on: %i[create]

  private

  def add_default_avatar
    unless avatar.attached?
      file = URI.open("https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg")
      self.avatar.attach(io: file, filename: "avatar-default.png", content_type: "image/png")
      self.save
    end
  end
end
