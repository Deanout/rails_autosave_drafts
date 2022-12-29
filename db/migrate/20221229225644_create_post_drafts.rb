class CreatePostDrafts < ActiveRecord::Migration[7.0]
  def change
    create_table :post_drafts do |t|
      t.string :title

      t.timestamps
    end
  end
end
