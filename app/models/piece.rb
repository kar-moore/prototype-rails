class Piece < ActiveRecord::Base
  # extend FriendlyId
  # friendly_id :slug_candidates, use: :slugged

  default_scope { order('created_at DESC') }
  scope :recent, -> { order('created_at DESC').limit(20) }

  acts_as_ordered_taggable

  has_and_belongs_to_many :images
  has_and_belongs_to_many :series

  belongs_to :section
  belongs_to :issue

  has_one :article, autosave: false

  before_save :update_tag_list

  validates :slug, presence: true, uniqueness: true, length: {minimum: 5, maximum: 80}, format: {with: /\A[a-z0-9-]+\z/}

  NO_PRIMARY_TAG = 'NO_PRIMARY_TAG'

  # Virtual attribute primary_tag and normal_tags. Both string
  def primary_tag=(primary_tag)
    if primary_tag.blank?
      @primary_tag = NO_PRIMARY_TAG
    else
      @primary_tag = primary_tag
    end
  end

  # Use this instead of the original tag_list function
  # When the object is loaded from version hash, tag_list will not be available
  # However, taggings do work. Therefore, recreate tag_list in this way
  def my_tag_list
    self.taggings.map(&:tag).map(&:name)
  end

  def primary_tag
    tag = @primary_tag || my_tag_list.first

    if tag == NO_PRIMARY_TAG
      nil
    else
      tag
    end
  end

  def tags=(normal_tags)
    @tags = normal_tags
  end

  def tags
    @tags ||= my_tag_list.drop(1)
  end

  def tags_string
    self.tags.join(',')
  end

  def tags_string=(tags_string)
    self.tags = tags_string.split(',')
  end

  # Return a human-readable name of the piece. For now, if the piece contains article(s), return the title of the first article. Otherwise, if it contains images, return the caption of the first image. If it contains neither, return 'Empty piece'. Might need a better approach. FIXME
  def name
    return self.article.headline if self.article

    if self.images.any?
      caption = self.images.first.caption

      if caption.blank?
        return 'Uncaptioned Image'
      else
        return caption
      end
    end

    'Empty piece'
  end

  def title
    if self.primary_tag
      "#{primary_tag.upcase}: #{self.name}"
    else
      self.name
    end
  end

  private
    def update_tag_list
      self.tag_list = [self.primary_tag || NO_PRIMARY_TAG] + self.tags
    end
end
