require "rails_helper"

RSpec.describe "Classes API", type: :request do
  describe "GET /schools/:school_id/classes" do
    it "returns classes for school" do
      school = create(:school)
      school_class = create(:school_class, school: school)
      create(:student, school: school, school_class: school_class)

      get "/schools/#{school.id}/classes"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"].size).to eq(1)
      expect(json["data"][0]["id"]).to eq(school_class.id)
      expect(json["data"][0]["number"]).to eq(10)
      expect(json["data"][0]["letter"]).to eq("A")
      expect(json["data"][0]["students_count"]).to eq(1)
    end

    it "returns 404 when school does not exist" do
      get "/schools/999/classes"

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json["error"]).to eq("School not found")
    end
  end
end