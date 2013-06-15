Fabricator(:invite) do
	full_name { Faker::Name.name }
	invitee_email { Faker::Internet.email }
end