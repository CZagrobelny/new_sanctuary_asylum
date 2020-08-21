module Select
  def get_from_select2(options)
    field_id = options[:from][:id]
    page.evaluate_script("$('##{field_id}').val()")
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