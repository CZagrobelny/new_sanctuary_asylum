module Select
  def select_from_chosen(item_text, options)
    field_id = options[:from][:id]
    option_value = page.evaluate_script("$(\"##{field_id} option:contains('#{item_text}')\").val()")
    page.execute_script("$('##{field_id}').val('#{option_value}')")
  end

  def get_from_chosen(options)
    field_id = options[:from][:id]
    page.evaluate_script("$('##{field_id}').val()")
  end

  def select_from_multi_chosen(item_text, options)
    field_id = options[:from][:id]
    within "##{field_id}_chosen" do
      find('.chosen-search-input').click
      find("ul.chosen-results").find("li", :text => item_text).click
    end
  end

  def select_date_and_time(date, options = {})
    field = options[:from]
    select date.strftime('%Y'), :from => "#{field}_1i" #year
    select date.strftime('%B'), :from => "#{field}_2i" #month
    select date.strftime('%-d'), :from => "#{field}_3i" #day 
    select date.strftime('%H'), :from => "#{field}_4i" #hour
    select date.strftime('%M'), :from => "#{field}_5i" #minute
  end
end