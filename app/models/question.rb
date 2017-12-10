class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates_presence_of :title, :body
end
