class Item < ActiveRecord::Base

  attr_reader :image_crop_data

  validates :price, numericality: { greater_than: 0 , allow_nil: true }
  validates :name, :price, presence: true

  # has_and_belongs_to_many :carts
  has_many                :positions
  has_many :carts, through: :positions

  has_many :comments, as: :commentable

  has_and_belongs_to_many :orders

  mount_uploader :image, ImageUploader

  acts_as_taggable

  def crop_image!(c)
    c.each { |k, v| c[k] = v.to_i }
    @image_crop_data = c
    image.recreate_versions!
  end
end
