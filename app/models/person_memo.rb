# == Schema Information
#
# Table name: person_memos
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint           not null
#
# Indexes
#
#  index_person_memos_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
class PersonMemo < ApplicationRecord
  belongs_to :person, dependent: :destroy
end
