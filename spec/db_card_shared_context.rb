require 'csv'

shared_context 'db_card' do
  before do
    CSV.foreach('db/cards.csv') do |row|
      person = Person.create(id: row[0])
      person.strict_loading!(false)
      card = Card.new(
        name: row[1],
        email: row[2],
        organization: row[3],
        department: row[4],
        title: row[5],
      )
      person.cards << card

      if row[6].present?
        memo = person.build_memo(content: row[6])
        memo.save!
      end
    end
  end
end
