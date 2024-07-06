# frozen_string_literal: true

require 'csv'
require 'aws-sdk-s3'

# reset tables
begin
  ActiveRecord::Base.connection.execute('START TRANSACTION')
  Person.destroy_all
  ActiveRecord::Base.connection.execute('ALTER TABLE cards AUTO_INCREMENT = 1')
  ActiveRecord::Base.connection.execute('ALTER TABLE people AUTO_INCREMENT = 1')
  ActiveRecord::Base.connection.execute('COMMIT')
rescue StandardError => e
  ActiveRecord::Base.connection.execute('ROLLBACK')
  raise e
end

# insert seeds data
ActiveRecord::Base.transaction do
  CSV.foreach('db/cards.csv') do |row|
    person = Person.create(id: row[0])
    card = Card.new(
      name: row[1],
      email: row[2],
      organization: row[3],
      department: row[4],
      title: row[5],
    )

    person.cards << card
    SampleCardImageUploader.upload(card)

    if row[6].present?
      memo = person.build_memo(content: row[6])
      memo.save!
    end
  end

  add_card = Card.new(
    person_id: 19,
    name: '矢島 秀司',
    email: 'yazima2006@example.com',
    organization: '株式会社ピーマン',
    department: '広報部',
    title: '広報',
  )
  add_card.save!
  SampleCardImageUploader.upload(add_card)
end
