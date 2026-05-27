class ClassService
  def self.list_by_school(school_id)
    school = School.find_by(id: school_id)

    return { success: false, status: :not_found, error: "School not found" } if school.nil?

    { success: true, classes: school.school_classes }
  end
end