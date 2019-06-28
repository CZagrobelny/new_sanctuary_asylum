class DraftsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access_to_community, except: [:approve]
  before_action :require_admin_or_access_to_friend, except: [:approve]
  before_action :require_admin_or_access_time_slot, only: [:destroy]
  before_action :require_regional_admin_or_remote_lawyer_with_access_to_friend, only: [:approve]

  def new
    @draft = friend.drafts.new
    @application = friend.applications.new
  end

  def create
    ActiveRecord::Base.transaction do
      @application = friend.applications.find_or_initialize_by(category: application_params[:category])
      @application.save!
      @draft = application.drafts.new(draft_params.merge(friend: friend))
      @draft.save!
    end
    flash[:success] = 'Application draft saved.'
    render_document_list
  rescue StandardError => e
    @draft ||= application.drafts.new(draft_params.merge(friend: friend))
    flash.now[:error] = 'Application draft not saved.'
    render :new
  end

  def edit
    if draft.reviews.present?
      flash[:alert] = 'This draft has already been reviewed and can not be edited. Please submit a new draft.'
      render_document_list
    else
      draft
      application
      friend
    end
  end

  def update
    if update_draft_and_application_assignment
      flash[:success] = 'Application draft saved.'
      render_document_list
    else
      friend
      flash.now[:error] = 'Friend record not saved.'
      render :edit
    end
  end

  def index
    friend
  end

  def destroy
    if destroy_draft
      flash[:success] = 'Application draft destroyed.'
      redirect_to edit_community_admin_friend_path(current_community.slug, friend, tab: '#documents')
    else
      flash[:error] = 'Error destroying application draft.'
      redirect_to community_friend_drafts_path(current_community.slug, friend)
    end
  end

  def submit_for_review
    if draft.update_status(:in_review)
      notify_lawyer(draft)
      flash[:success] = 'Draft submitted for review.'
    else
      flash[:error] = 'There was an issue submitting the draft for review.'
    end
    render_document_list
  end

  def approve
    if draft.update_status(:approved)
      if friend.users.where(user_friend_associations: { remote: false }).present?
        ReviewMailer.application_approved_email(application).deliver_now
      end
      flash[:success] = 'Draft approved.'
    else
      flash[:error] = 'There was an issue approving the draft.'
    end
    if current_user.regional_admin?
      redirect_to regional_admin_region_friend_path(friend.region, friend)
    else
      redirect_to remote_clinic_friend_path(friend)
    end
  end

  private

  def notify_lawyer(draft)
    Notification.draft_for_review(draft: draft)
  end

  def render_document_list
    if current_user.admin_or_has_active_access_time_slot?
      redirect_to edit_community_admin_friend_path(current_community.slug, friend, tab: '#documents')
    else
      redirect_to community_friend_path(current_community.slug, friend, tab: '#documents')
    end
  end

  def draft
    @draft ||= Draft.find(params[:id])
  end

  def application
    @application ||= draft.application
  end

  def friend
    @friend ||= current_community.friends.find(params[:friend_id])
  end

  def update_draft_and_application_assignment
    if application.category == application_params[:category]
      draft.update(draft_params)
    else
      ActiveRecord::Base.transaction do
        old_application = application
        @application = friend.applications.find_or_initialize_by(category: application_params[:category])
        application.save!
        draft.update(draft_params.merge(application_id: application.id))
        old_application.destroy! if old_application.drafts.empty?
      end
    end
    true
  rescue StandardError => e
    false
  end

  def destroy_draft
    ActiveRecord::Base.transaction do
      draft.destroy!
      application.destroy! if application.drafts.empty?
    end
    true
  rescue StandardError => e
    false
  end

  def application_params
    params.require(:application).permit(
      :category
    )
  end

  def draft_params
    params.require(:draft).permit(
      :notes,
      :pdf_draft,
      user_ids: []
    )
  end

  def require_admin_or_access_to_friend
    return if current_user.admin_or_existing_relationship?(params[:friend_id])

    not_found
  end
end
