class LocGroupsController < ApplicationController
  before_filter :require_admin

  def index
    @loc_groups = @department.loc_groups.select { |lg| current_user.can_admin?(lg) }
  end

  def show
    @loc_group = LocGroup.find(params[:id])
  end

  def new
    @loc_group = @department.loc_groups.build
  end

  def create
    @loc_group = LocGroup.new(params[:loc_group])
    if @loc_group.save
      flash[:notice] = "Successfully created loc group."
      redirect_to @loc_group
    else
      render :action => 'new'
    end
  end

  def edit
    @loc_group = LocGroup.find(params[:id])
  end

  def update
    @loc_group = LocGroup.find(params[:id])
    if @loc_group.update_attributes(params[:loc_group])
      flash[:notice] = "Successfully updated loc group."
      redirect_to @loc_group
    else
      render :action => 'edit'
    end
  end

  def destroy
    @loc_group = LocGroup.find(params[:id])
    @loc_group.destroy
    flash[:notice] = "Successfully destroyed loc group."
    redirect_to department_loc_groups_path(current_department)
  end

  private
  # TODO: do we want finer role control: sth in between of department admin and loc group admin?
  # Ben says "no" and Nathan can't think of a use case.
  def require_admin
    redirect_to(access_denied_path) unless current_user.is_admin_of?(@department)
  end
end

