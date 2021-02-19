module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authorize_access_request!, except: [:show, :index]
      before_action :set_comment, only: [:show, :update, :destroy]
      before_action :find_commentable, only: :create

      # GET /comments
      def index
        @comments = Comment.all

        render json: @comments
      end

      # GET /comments/1
      def show
        render json: @comment
      end

      # POST /comments
      def create
        @comment = @commentable.comments.new(comment_params)

        if @comment.save
          render json: @comment, status: :created, location: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /comments/1
      def update
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      # DELETE /comments/1
      def destroy
        @comment.destroy
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_comment
        @comment = Comment.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def comment_params
        params.require(:comment).permit(:content, :user_id, :commentable_id, :commentable_type)
      end

      def find_commentable
        if params[:comment_id]
          @commentable = Comment.find_by_id(params[:comment_id])
        elsif params[:question_id]
          @commentable = Question.find_by_id(params[:question_id])
        end
      end
    end
  end
end
