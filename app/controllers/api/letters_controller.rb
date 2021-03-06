class Api::LettersController < ApplicationController
  before_action :check_login

  def star
    @letter = Letter.find(params[:id])
      if @letter.star.present?
        @letter.update(star: false)
        render json: { result: 'remove' }
      else
        @letter.update(star: true)
        render json: { result: 'add' }
      end
  end

  def trash
    if params[:letter_ids]
      letter_ids = params[:letter_ids]
      letter_ids.each do |id|
        letter = Letter.with_deleted.find(id)
        if letter.deleted_at
          letter.really_destroy!
        else
          letter_with_labels = LetterWithLabel.where(letter_id: id)
          letter_with_labels.each do |letter_with_label|
            letter_with_label.delete
          end
          letter.destroy
        end
      end
    end
  end
  
  def add_label_to_letters
    letter_ids = params[:letter_ids]
    label = current_user.labels.find(params[:label_id])
    letter_ids.each do |id|
      if !LetterWithLabel.where(label_id: label, letter_id: id).present?
        letter = Letter.find(id)
        letter.labels << label
        letter.save
      end
    end
  end

  def add_label
    letter_id = params[:letter_id]
    label = current_user.labels.find(params[:label_id])
    if !LetterWithLabel.where(label_id: params[:label_id], letter_id: letter_id).present?
      letter = Letter.find(letter_id)
      letter.labels << label
      letter.save
    end
  end

  def delete_label
    letter_with_label = LetterWithLabel.where(label_id: params[:label_id], letter_id: params[:letter_id])
    LetterWithLabel.destroy(letter_with_label.ids)
  end

  def read
    @letter = Letter.with_deleted.find(params[:letterId])
    if !@letter.read
      @letter.update(read: true)
    end
  end

  private 

  def check_login
    if !user_signed_in?
      render json: { status: 'fail', message: 'you need to login first!' }, status: 401
    end
  end
end