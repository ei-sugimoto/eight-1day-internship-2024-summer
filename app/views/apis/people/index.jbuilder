json.array! @people do |person|
  json.id person.id
  json.cards do
    json.array! person.cards.each do |card|
      json.id card.id
      json.name card.name
      json.organization card.organization
    end
  end
  json.memo person.memo&.content
end
