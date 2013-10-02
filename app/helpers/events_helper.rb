module EventsHelper

  def list_events(date, events)
    title = _('Events for %s') % show_date_month(date)
    content_tag('h2', title) +
    content_tag('div',
      (events.any? ?
        content_tag('table', events.select { |item| item.display_to?(user) }.map {|item| display_event_in_listing(item)}.join('')) :
        content_tag('em', _('No events for this month'), :class => 'no-events')
      ), :id => 'agenda-items'
    )
  end

  def display_event_in_listing(article)
    
    content_tag( 'tr',
      content_tag('td',
        show_date(article.start_date,true) + '<br>' +
        link_to(article.name, article.url) + '<br>' +
        (article.address.include?('#') ? 'Indefined place' : 'Place: ' + article.address)),:class => 'agenda-item')
    
    
    #content_tag( 'tr', content_tag('td', show_date(article.start_date,true)), :class => 'agenda-date') +
        
    #content_tag( 'tr', content_tag('td', link_to(article.name, article.url, :class => icon_for_article(article))), :class => 'agenda-item') + 
    #content_tag( 'tr', content_tag('td', article.address.include?('#') ? 'Indefined place' : 'Place: ' + article.address) , :class => 'agenda-local')
  end

  def populate_calendar(selected_date, events)
    events.reject! {|event| !event.display_to?(user)}
    calendar = Event.date_range(selected_date.year, selected_date.month).map do |date|
      [
        # the day itself
        date,
        # is there any events in this date?
        events.any? {|event| event.date_range.include?(date)},
        # is this date in the current month?
        true
      ]
    end
    # pad with days before
    while calendar.first.first.wday != 0
      calendar.unshift([calendar.first.first - 1.day, false, false])
    end

    # pad with days after (until Saturday)
    while calendar.last.first.wday != 6
      calendar << [calendar.last.first + 1.day, false, false]
    end
    calendar
  end

end
