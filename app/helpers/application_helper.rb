# encoding: UTF-8
module ApplicationHelper

  def menu_entry caption, action, level, sel=false
    render :partial => 'shared/menu_entry', :locals => {
      :td_class => 'navLevel' + level.to_s,
      :link_class => 'navLevel' + level.to_s + if sel then 'sel' else '' end,
      :action => action,
      :caption => caption,
      :image => sel
    }
  end
  
  def picture_tag id, flag
    img = image_tag url_for(:action => 'picture_thumb', :flag => flag, :picture_id => id) + '.png'
#    link_to img, {:action => 'description', :id => id}, {:target => '_blank', :style => "border:0px none;"}
  end
  
  def picture_icon_tag id, flag
    img = image_tag url_for(:action => 'picture_thumb', :flag => false, :picture_id => id) + '.png'
    #link = link_to img, {:action => 'description', :id => id}, {:target => '_blank', :style => "border:0px none;"}
    link = link_to_remote img,  :url => {:controller => "/search", :action => 'update_image', :picture_id => id }
    if !flag
     '<div style="float:left;">' + link + '<br>' +
        check_box_tag("p_" + id.id.to_s, 1, false) +
        'Удалить'.force_coding +
      '</div>'
    else
      link
    end  
  end
  
  # Concatenates all elements in list, omitting nil or zero-length elements,
  # with separator between elements
#  def string_list(list, separator)
#    result = ""
#    list.each { |e|
#      unless e.blank?
#        result += e + separator
#      end
#    }
#    result.chomp(separator)
#  end
  
  def date_picker_field(object, method)
    obj = instance_eval("@#{object}")
    value = obj.send(method)
    display_value = value.respond_to?(:strftime) ? value.strftime('%d %b %Y') : value.to_s
    display_value = '[ ' + 'Выбрать дату' + ' ]' if display_value.blank?

    out = hidden_field(object, method)
    out << content_tag('a', display_value, :href => '#',
        :id => "_#{object}_#{method}_link", :class => '_demo_link',
        :onclick => "DatePicker.toggleDatePicker('#{object}_#{method}'); return false;")
    out << tag('div', :class => 'date_picker', :style => 'display: none',
                      :id => "_#{object}_#{method}_calendar")
    if obj.respond_to?(:errors) and obj.errors.on(method) then
      ActionView::Base.field_error_proc.call(out, nil) # What should I pass ?
    else
      out
    end
  end

#  def short_date(date)
#    date.nil? ? '' : date.strftime('%d.%m %Y')
#  end
  
  def short_datetime(date)
    date.nil? ? '' : date.strftime('%d.%m %Y %H:%M')
  end
  
  def create_update_info record, separator = ', '
    return '' if record.nil?
    txt = ''
    cb = record.created_by
    ca = record.created_at
    ub = record.updated_by
    ua = record.updated_at
    
    txt << 'Angelegt' + ': '
    if cb
      txt << h(cb)
    else
      txt << '---'
    end
    if cb && ca
      txt << '/'
    end
    if ca
      txt << short_datetime(ca)
    end
    
    if (cb || ca) && (ub || ua)
      txt << separator + 'aktualisiert' + ': '
    end

    if ub
      txt << h(ub)
    else
      txt << '---'
    end
    if ub && ua
      txt << '/'
    end
    if ua
      txt << short_datetime(ua)
    end
    
    txt
  end
  
  def sortable field, caption
    link_to caption, :action => 'list', :sort_column => field
  end

  def score search_result, brackets = true
    t = ''
    t << ' ('  if brackets
  
    s = (search_result.ferret_score * 100).round
    t << s.to_s
    t << '%'
    t << ')' if brackets
    t
  end
  
#  def address_text address_by_date, separator = nil
#    return '' if address_by_date.nil?
#    separator = '<br>' if separator.nil?
#    render :partial => '/shared/address_text', :locals => {
#      :address_by_date => address_by_date,
#      :separator => separator
#    }
#  end
  
#  def entry_field ini, caption, field, parents, action_new, action_edit, auto_complete_function = 'auto_complete_on_select'
#    render :partial => '/shared/entry_field', :locals => {
#      :initial => ini,
#      :caption => caption,
#      :field => field,
#      :parents => parents,
#      :action_new => action_new,
#      :action_edit => action_edit,
#      :auto_complete_function => auto_complete_function
#    }
#  end
   
  def text_field_with_auto_complete_with_custom_url(object, method, url_options = {}, tag_options = {}, completion_options = {})
    resp = ''
    resp << (completion_options[:skip_style] ? "" : auto_complete_stylesheet)
    resp << text_field(object, method, tag_options)
    resp << content_tag("div", "", :id => "#{object}_#{method}_auto_complete", :class => "auto_complete")
    acf = auto_complete_field("#{object}_#{method}", { :url => { :action => "auto_complete_for_#{object}_#{method}" }.update(url_options) }.update(completion_options))
    resp << acf
    resp
  end
  
#  def selection_params obj
#    if obj.kind_of? Array
#      arr = obj
#    else
#      arr = [obj]
#    end
#
#    s = ''
#    arr.each do |o|
#      ['id', 'name', 'name_for_id'].each do |f|
#        s << pair_param(o, f)
#        s << '+'
#      end
#    end
#    s.chomp('+')
#  end
  
#  def pair_param obj, fld
#    '\'&' + obj + '[' + fld + ']=\'+$(\'' + obj + '_' + fld + '\').value'
#  end
  
#  def field_values o
#    s = ''
#    ['id', 'name', 'name_for_id'].each do |f|
#      s << pair_param(o, f)
#      s << '+'
#    end
#    s.chomp('+')
#  end
end
