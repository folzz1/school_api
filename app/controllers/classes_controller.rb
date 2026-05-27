class ClassesController < ApplicationController
  def index
    result = ClassService.list_by_school(params[:school_id])

    if result[:success]
      render json: {
        data: result[:classes].map { |school_class| class_json(school_class) }
      }, status: :ok
    else
      render json: { error: result[:error] }, status: result[:status]
    end
  end

  private

  def class_json(school_class)
    {
      id: school_class.id,
      number: school_class.number,
      letter: school_class.letter,
      students_count: school_class.students.count
    }
  end
end