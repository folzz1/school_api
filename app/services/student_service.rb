class StudentService
  def self.create(params)
    school_class = SchoolClass.find_by(
      id: params[:class_id],
      school_id: params[:school_id]
    )

    return { success: false, status: :unprocessable_entity, errors: ["Class not found in this school"] } if school_class.nil?

    student = Student.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      surname: params[:surname],
      school_id: params[:school_id],
      school_class_id: params[:class_id]
    )

    if student.save
      { success: true, student: student }
    else
      { success: false, status: :unprocessable_entity, errors: student.errors.full_messages }
    end
  end

  def self.delete(student_id:, token:)
    student = Student.find_by(id: student_id)

    return { success: false, status: :bad_request, error: "Student not found" } if student.nil?

    unless TokenService.valid?(student.id, token)
      return { success: false, status: :unauthorized, error: "Invalid authorization" }
    end

    student.destroy

    { success: true }
  end

  def self.list_by_class(school_id:, class_id:)
    Student.where(
      school_id: school_id,
      school_class_id: class_id
    )
  end
end