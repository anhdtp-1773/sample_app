class Micropost < ApplicationRecord
  belongs_to :user

  scope :by_lastest, -> { order(created_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
            length: { maximum: Settings.max_content_length }
  validate  :picture_size

  private

  def picture_size
    if picture.size > Settings.size_picture.megabytes
      errors.add(:picture, I18n.t(".should_be_less_than_5MB"))
    end
  end
end
