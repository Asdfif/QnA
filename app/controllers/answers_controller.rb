class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :answer, only: %i[update destroy make_it_best delete_file]
  
  after_action :publish_answer, only: %i[create]
  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = question
    # respond_to do |format|
       @answer.save
    #     format.json do 
    #       render json: { answer: @answer,  links: @answer.links, files: answer_files_array }
    #     end
    #     format.js { render :js }
    #   else
    #     format.json do 
    #       render json: @answer.errors.full_messages, status: :unprocessable_entity 
    #     end
    #   end
    # end
  end

  def update
    @answer.update(answer_params) if current_user.owner_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.owner_of?(@answer)
  end

  def make_it_best
    if current_user&.owner_of?(@answer.question)
      question = @answer.question
      @prev_best_answer_id = question.best_answer&.id
      @answer.make_it_best
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, 
                                   files: [], 
                                   links_attributes: [:name, :url, :_destroy])
  end

  def answer_files_array
    @answer.files.map do |file|
      [file.filename.to_s , url_for(file), file.id]
    end
  end

  def answer_links_array 
    @answer.links.map do |link|
      [link.name, link.url]
    end
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast( 
      "questions/#{params[:question_id]}/answers", 
      { 
        author_id: @answer.user_id, 
        answer: @answer,
        files: answer_files_array,
        links: answer_links_array
      } 
    )
  end

  # def render_answer
  #   ApplicationController.renderer.instance_variable_set(:@env, { "warden" => warden })

  #   ApplicationController.render(
  #     partial: 'answers/answers',
  #     locals: { answers: question.answers },
  #     author_id: @answer.user_id )
  # end
end
