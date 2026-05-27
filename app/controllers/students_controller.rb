class StudentsController < ApplicationController
  def create
    result = StudentService.create(student_params)

    if result[:success]
      student = result[:student]

      response.set_header("X-Auth-Token", TokenService.generate(student.id))

      render json: student_json(student), status: :created
    else
      render json: { errors: result[:errors] }, status: :method_not_allowed
    end
  end

  def destroy
    result = StudentService.delete(
      student_id: params[:user_id],
      token: bearer_token
    )

    if result[:success]
      head :ok
    else
      render json: { error: result[:error] }, status: result[:status]
    end
  end

  def index
    students = StudentService.list_by_class(
      school_id: params[:school_id],
      class_id: params[:class_id]
    )

    render json: {
      data: students.map { |student| student_json(student) }
    }, status: :ok
  end

  private

  def student_params
    params.permit(:first_name, :last_name, :surname, :school_id, :class_id)
  end

  def bearer_token
    header = request.headers["Authorization"]
    return nil if header.blank?

    header.split("Bearer ").last
  end

  def student_json(student)
    {
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      surname: student.surname,
      class_id: student.school_class_id,
      school_id: student.school_id
    }
  end
end