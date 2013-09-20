class EventsController < PublicController

  needs_profile

  def events
    @selected_day = nil
    @selected_month = nil
    @events_of_the_day = []
    @events_of_the_month = []
    date = build_date(params[:year], params[:month], params[:day])

    if params[:day] || !params[:year] && !params[:month]
      @selected_month = date
      @events_of_the_month = profile.events.by_month(@selected_month)
   end

   if params[:month] && params[:year]
      @selected_month = date
      @events_of_the_month = profile.events.by_month(@selected_month)
   end

   if params[:month] && params[:year] && params[:day]
      @selected_month = date
      @events_of_the_month = profile.events.by_month(@selected_month)
   end


    events = profile.events.by_range((date - 1.month).at_beginning_of_month..(date + 1.month).at_end_of_month)

    @calendar = populate_calendar(date, events)
    @previous_calendar = populate_calendar(date - 1.month, events)
    @next_calendar = populate_calendar(date + 1.month, events)
  end

  def events_by_day
    @selected_day = build_date(params[:year], params[:month], params[:day])
    @events_of_the_day = profile.events.by_day(@selected_day)
    render :partial => 'events_by_day'
  end

  protected

  include EventsHelper

end
