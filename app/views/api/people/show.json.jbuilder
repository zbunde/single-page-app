json._links do
  json.self do
    json.href api_person_path(@person)
  end
end

json.first_name @person.first_name
json.last_name @person.last_name
json.address @person.address
