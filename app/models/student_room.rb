class StudentRoom < ActiveRecord::Base
  belongs_to :user
  belongs_to :room

  validates :status, inclusion: {in: %w(Pending Reserved Completed), message: "%{value} is not a valid enrollment status in STUDENT_ROOM"}
  validates :grade, inclusion: {in: %w(A+ A A- B+ B B- C+ C C- F), message: "%{value} is not a valid grade"}
  
end
