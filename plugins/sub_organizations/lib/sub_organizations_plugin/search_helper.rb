require_dependency 'search_helper'

module SubOrganizationsPlugin::SearchHelper

  include SearchHelper

  def display_selectors(display, float = 'right')
    display = 'compact' if display.blank?
    compact_link = display == 'compact' ? _('Compact') : link_to(_('Compact'), params.merge(:display => 'compact'))
    map_link = display == 'map' ? _('Map') : link_to(_('Map'), params.merge(:display => 'map'))
    full_link = display == 'full' ? _('Full') : link_to(_('Full'), params.merge(:display => 'full'))
    content_tag('div', 
      content_tag('strong', _('Display')) + ': ' + [compact_link, map_link, full_link].compact.join(' | ').html_safe,
      :class => 'search-customize-options'
    )
  end


end
