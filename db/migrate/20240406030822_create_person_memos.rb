class CreatePersonMemos < ActiveRecord::Migration[7.0]
  def change
    create_table :person_memos do |t|
      t.references :person, null: false, foreign_key: true
      t.text :content
      t.timestamps
    end
  end
end
