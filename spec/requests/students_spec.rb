require "rails_helper"

RSpec.describe "Students API", type: :request do
  describe "POST /students" do
    it "creates student and returns auth token" do
      school = create(:school)
      school_class = create(:school_class, school: school)

      post "/students",
           params: {
             first_name: "Ivan",
             last_name: "Ivanov",
             surname: "Ivanovich",
             school_id: school.id,
             class_id: school_class.id
           },
           as: :json

      expect(response).to have_http_status(:created)
      expect(response.headers["X-Auth-Token"]).to be_present

      json = JSON.parse(response.body)

      expect(json["id"]).to be_present
      expect(json["first_name"]).to eq("Ivan")
      expect(json["last_name"]).to eq("Ivanov")
      expect(json["surname"]).to eq("Ivanovich")
      expect(json["school_id"]).to eq(school.id)
      expect(json["class_id"]).to eq(school_class.id)
    end

    it "returns 405 when class does not belong to school" do
      school = create(:school)
      another_school = create(:school)
      school_class = create(:school_class, school: another_school)

      post "/students",
           params: {
             first_name: "Ivan",
             last_name: "Ivanov",
             surname: "Ivanovich",
             school_id: school.id,
             class_id: school_class.id
           },
           as: :json

      expect(response).to have_http_status(:method_not_allowed)

      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Class not found in this school")
    end

    it "returns 405 when required fields are missing" do
      school = create(:school)
      school_class = create(:school_class, school: school)

      post "/students",
           params: {
             first_name: "",
             last_name: "",
             surname: "",
             school_id: school.id,
             class_id: school_class.id
           },
           as: :json

      expect(response).to have_http_status(:method_not_allowed)

      json = JSON.parse(response.body)
      expect(json["errors"]).to be_present
    end
  end

  describe "GET /schools/:school_id/classes/:class_id/students" do
    it "returns students from class" do
      school = create(:school)
      school_class = create(:school_class, school: school)

      student = create(
        :student,
        school: school,
        school_class: school_class,
        first_name: "Petr"
      )

      get "/schools/#{school.id}/classes/#{school_class.id}/students"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json["data"].size).to eq(1)
      expect(json["data"][0]["id"]).to eq(student.id)
      expect(json["data"][0]["first_name"]).to eq("Petr")
      expect(json["data"][0]["school_id"]).to eq(school.id)
      expect(json["data"][0]["class_id"]).to eq(school_class.id)
    end

    it "returns empty list when class has no students" do
      school = create(:school)
      school_class = create(:school_class, school: school)

      get "/schools/#{school.id}/classes/#{school_class.id}/students"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["data"]).to eq([])
    end
  end

  describe "DELETE /students/:user_id" do
    it "deletes student with valid token" do
      school = create(:school)
      school_class = create(:school_class, school: school)
      student = create(:student, school: school, school_class: school_class)

      token = TokenService.generate(student.id)

      delete "/students/#{student.id}",
             headers: {
               "Authorization" => "Bearer #{token}"
             }

      expect(response).to have_http_status(:ok)
      expect(Student.find_by(id: student.id)).to be_nil
    end

    it "returns 401 with invalid token" do
      school = create(:school)
      school_class = create(:school_class, school: school)
      student = create(:student, school: school, school_class: school_class)

      delete "/students/#{student.id}",
             headers: {
               "Authorization" => "Bearer wrong_token"
             }

      expect(response).to have_http_status(:unauthorized)
      expect(Student.find_by(id: student.id)).to be_present

      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Invalid authorization")
    end

    it "returns 401 without token" do
      school = create(:school)
      school_class = create(:school_class, school: school)
      student = create(:student, school: school, school_class: school_class)

      delete "/students/#{student.id}"

      expect(response).to have_http_status(:unauthorized)
      expect(Student.find_by(id: student.id)).to be_present
    end

    it "returns 400 when student does not exist" do
      delete "/students/999",
             headers: {
               "Authorization" => "Bearer anything"
             }

      expect(response).to have_http_status(:bad_request)

      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Student not found")
    end
  end
end