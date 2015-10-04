class Cart < ActiveRecord::Base

  has_many                         :positions
  belongs_to                        :user
  has_and_belongs_to_many :items
  has_many                         :items, through: :positions

end
