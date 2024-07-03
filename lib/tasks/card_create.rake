require 'csv'

namespace :card_create do
  task additional: :environment do
    CSV.foreach('db/additional_cards.csv') do |row|
      params = {
        name: row[0],
        email: row[1],
        organization: row[2],
        department: row[3],
        title: row[4],
      }

      Card.new(params).register
    end

    puts '全ての登録が完了しました。'.green
  end
end

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end
end
