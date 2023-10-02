class Comment < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :post

  # validations
  validates :content, presence: true
  validates :rating, inclusion: { in: [1, 2, 3, 4, 5] }
  validates :post, uniqueness: { scope: :user }

  def time_ago
    diff = DateTime.now.to_f - self.created_at.to_f
    if diff > 86_400
      nb_days = diff.fdiv(86_400).to_i
      return "#{nb_days} #{nb_days >= 2 ? 'jours' : 'jour'}"
    elsif diff > 3_600
      nb_hours = diff.fdiv(3_600).to_i
      return "#{nb_hours} #{nb_hours >= 2 ? 'heures' : 'heure'}"
    else
      nb_minutes = diff.fdiv(60).to_i
      return "#{nb_minutes} #{nb_minutes >= 2 ? 'minutes' : 'minute'}"
    end
  end
end
