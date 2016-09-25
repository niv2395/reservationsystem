class Announcement < ActiveRecord::Base
  belongs_to :room

  validates :title, presence: true, length: {maximum: 100}
  validates :content, presence: true, length: {maximum: 1000}
end
