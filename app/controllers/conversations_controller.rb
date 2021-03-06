class ConversationsController < ApplicationController


  def index
    @users = User.all
    @conversations = Conversation.all
  end

  def create
    if Conversation.between(params[:sender_id],params[:receiver_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:receiver_id]).first

    else
      @conversation = Conversation.create!(conversation_params)
    end
    redirect_to conversation_messages_path(@conversation)
  end

    def show
    # @room = Room.find(params[:id])
        @conversations = Conversation.where(sender_id:current_user.id)
    end
private
  def conversation_params
    params.permit(:sender_id, :receiver_id)
  end
end
