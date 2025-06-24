class CreateImageRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :image_requests do |t|
      t.string :title
      t.text :diagnosis

      t.timestamps
    end
  end
end
