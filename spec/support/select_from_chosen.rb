module Select
  def select_from_chosen(item_text, options)
    field_id = options[:from][:id]
    option_value = page.evaluate_script("$(\"##{field_id} option:contains('#{item_text}')\").val()")
    page.execute_script("$('##{field_id}').val('#{option_value}')")
  end

  def select_date_and_time(date, options = {})
    field = options[:from]
    select date.strftime('%Y'), :from => "#{field}_1i" #year
    select date.strftime('%B'), :from => "#{field}_2i" #month
    select date.strftime('%d'), :from => "#{field}_3i" #day 
    select date.strftime('%H'), :from => "#{field}_4i" #hour
    select date.strftime('%M'), :from => "#{field}_5i" #minute
  end
end