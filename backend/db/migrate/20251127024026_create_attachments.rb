class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.references :discussion_thread, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.string :url
      t.text :extrainfo

      t.timestamps
    end
  end
end
