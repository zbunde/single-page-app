json._links do
  json.self do
    json.href api_people_path
  end
end

json._embedded do
  json.person do
    json.first_name nil
    json.last_name nil
    json.address nil
  end
  json.people do
    json.array! @people do |person|
      json._links do
        json.self do
          json.href api_person_path(person)
        end
      end
      json.first_name person.first_name
      json.last_name person.last_name
      json.address person.address
    end
  end
end