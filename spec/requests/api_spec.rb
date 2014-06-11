require 'rails_helper'

describe 'People API' do

  describe 'GET /api/people' do

    it 'returns a hypermedia api response with people' do
      person1 = Person.create!(
        first_name: "Joe",
        last_name: "Example",
        address: "15 main street"
      )
      person2 = Person.create!(
        first_name: "Edna",
        last_name: "Examplar",
        address: "16 main street"
      )

      get '/api/people', {}, { 'HTTP_ACCEPT' => 'application/json' }

      expect(JSON.parse(response.body)).to eq(
        {
          "_links" => {
            "self" => { "href" => api_people_path },
          },
          "_embedded" => {
            "person" => {
              "first_name" => nil,
              "last_name" => nil,
              "address" => nil,
            },
            "people" => [
              {
                "_links" => {
                  "self" => { "href" => api_person_path(person1) },
                },
                "first_name" => person1.first_name,
                "last_name" => person1.last_name,
                "address" => person1.address,
              },
              {
                "_links" => {
                  "self" => { "href" => api_person_path(person2) },
                },
                "first_name" => person2.first_name,
                "last_name" => person2.last_name,
                "address" => person2.address,
              },
            ]
          },
        }
      )

    end

  end

  describe 'POST /api/people' do

    it 'returns a hypermedia api response with the person that was created when the post was successful' do
      attributes = {
        first_name: "Joe",
        last_name: "Example",
        address: "15 Main St"
      }

      post(
        '/api/people',
        JSON.generate(attributes),
        { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
      )

      person = Person.order("id").last

      expect(JSON.parse(response.body)).to eq(
        {
          "_links" => {
            "self" => { "href" => api_person_path(person) },
          },
          "first_name" => "Joe",
          "last_name" => "Example",
          "address" => "15 Main St",
        }
      )
    end

    it 'returns an error status code and error messages when the save was not successful' do
      attributes = {
        first_name: "",
        last_name: "Example",
        address: "15 Main St"
      }

      post(
        '/api/people',
        JSON.generate(attributes),
        { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
      )

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq(
        {
          "full_messages" => ["First name can't be blank"],
          "fields" => ["first_name"]
        }
      )
    end

  end

  describe 'PATCH /api/people/:id' do

    let(:person) {
      Person.create!(
        first_name: "Joe",
        last_name: "Example",
        address: "15 Main St"
      )
    }

    it 'returns a hypermedia api response with the person that was created when the post was successful' do
      attributes = {
        first_name: "John",
        last_name: "Exemplar",
        address: "15 Elm St"
      }

      patch(
        "/api/people/#{person.to_param}",
        JSON.generate(attributes),
        { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
      )

      person.reload
      expect(person.first_name).to eq("John")
      expect(person.last_name).to eq("Exemplar")
      expect(person.address).to eq("15 Elm St")

      expect(JSON.parse(response.body)).to eq(
        {
          "_links" => {
            "self" => { "href" => api_person_path(person) },
          },
          "first_name" => "John",
          "last_name" => "Exemplar",
          "address" => "15 Elm St",
        }
      )
    end

    it 'returns an error status code and error messages when the save was not successful' do
      attributes = {
        first_name: "",
        last_name: "Other",
        address: "blah blah"
      }

      patch(
        "/api/people/#{person.to_param}",
        JSON.generate(attributes),
        { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
      )

      person.reload
      expect(person.last_name).to eq("Example")

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq(
        {
          "full_messages" => ["First name can't be blank"],
          "fields" => ["first_name"]
        }
      )
    end
  end

  describe 'DELETE /api/people/:id' do

    it 'returns a 200 response and deletes the person when the person is there' do
      person = Person.create!(
        first_name: "Joe",
        last_name: "Example",
        address: "15 Main St"
      )

      expect do
        delete(
          "/api/people/#{person.to_param}",
          {},
          { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
        )
      end.to change { Person.count }.by(-1)

      expect(response.status).to eq(200)
    end

    it 'returns a 200 response even if the person could not be found' do
      delete(
        "/api/people/0",
        {},
        { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
      )

      expect(response.status).to eq(200)
    end

  end

end