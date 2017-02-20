class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :slug
      t.integer :section_id
      t.integer :issue_id
      t.integer :rank,      default: 99

      t.timestamps
    end
  end
end
