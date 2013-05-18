Fabricator(:video) do
  title { "Game of Thrones"}
  description { Faker::Lorem.paragraph(2)}
end